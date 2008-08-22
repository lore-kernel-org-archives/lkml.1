Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbYHVVJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbYHVVJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 17:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbYHVVIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 17:08:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35198 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbYHVVIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 17:08:44 -0400
Message-ID: <48AF2ABD.9070100@zytor.com>
Date: Fri, 22 Aug 2008 14:08:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
References: <20080820162925.75a5e064@doriath.conectiva>	<48ADDF4F.2020401@zytor.com>	<48AE5FCF.6030103@zytor.com>	<20080822065012.GV14110@elte.hu>	<20080822113941.147a1db0@doriath.conectiva>	<20080822153451.GA8390@Krystal>	<20080822132948.57e47076@doriath.conectiva>	<20080822163520.GA9860@Krystal>	<20080822142054.403cbdef@doriath.conectiva> <20080822175741.6bc83dc8@doriath.conectiva>
In-Reply-To: <20080822175741.6bc83dc8@doriath.conectiva>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luiz Fernando N. Capitulino wrote:
> 
>  I have asked Mandriva and Ubuntu users to test this and all of
> them so far are saying that noreplace-paravirt works.
> 
>  It makes the system slower, but it works.
> 

Yes, the big issue is exactly what VirtualBox screws up in this matter, 
how to detect it, and how to work around it.

It's pretty clear it's a VirtualBox f*ckup at this point, but the 
failure mechanism isn't at all obvious and so far the workaround is elusive.

I'm strongly suspect this is a VirtualBox tcache management failure, but 
that doesn't help the situation without knowing how it happens.

	-hpa


