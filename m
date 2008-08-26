Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbYHZQOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbYHZQOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 12:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYHZQOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 12:14:09 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:47659 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbYHZQOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 12:14:08 -0400
Date: Tue, 26 Aug 2008 13:13:54 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Gerhard Brauer <gerhard.brauer@web.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080826131354.356ae11d@doriath.conectiva>
In-Reply-To: <20080826145338.GA8601@Krystal>
References: <48AE5FCF.6030103@zytor.com>
	<20080822065012.GV14110@elte.hu>
	<20080822113941.147a1db0@doriath.conectiva>
	<20080822153451.GA8390@Krystal>
	<20080822132948.57e47076@doriath.conectiva>
	<20080822163520.GA9860@Krystal>
	<20080822142054.403cbdef@doriath.conectiva>
	<20080822175741.6bc83dc8@doriath.conectiva>
	<48AF2ABD.9070100@zytor.com>
	<20080826141851.GA5300@tux1.brauer.lan>
	<20080826145338.GA8601@Krystal>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 26 Aug 2008 10:53:38 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> escreveu:

| Then, after having tested (2), try this on top of it :
| 
| In arch/x86/kernel/alternative.c, alternatives_smp_switch()
| 
| Add   unsigned long flags;
| Change 
| spin_lock -> spin_lock_irqsave(&smp_alt, flags);
| spin_unlock(&smp_alt); -> spin_unlock_irqrestore(&smp_alt, flags);

 Hmm, I can't find spin_lock functions in alternatives_smp_switch()
looks like the current implementation is now using mutexes.

 What tree are you referring to?

-- 
Luiz Fernando N. Capitulino
