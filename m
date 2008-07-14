Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbYGNUtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbYGNUtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 16:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbYGNUte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 16:49:34 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:59923 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464AbYGNUte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 16:49:34 -0400
Date: Mon, 14 Jul 2008 17:49:04 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, stable@kernel.org
Subject: Re: [PATCH] Fix typos from signal_32/64.h merge
Message-ID: <20080714174904.732299d1@doriath.conectiva>
In-Reply-To: <200807141740.23750.herton@mandriva.com.br>
References: <200807141740.23750.herton@mandriva.com.br>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.4; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 14 Jul 2008 17:40:23 -0300
Herton Ronaldo Krzesinski <herton@mandriva.com.br> escreveu:

| Fallout from commit 33185c504f8e521b398536b5a8d415779a24593c ("x86:
| merge signal_32/64.h")
| 
| Thanks to Dick Streefland who provided an useful testcase on
| http://lkml.org/lkml/2008/3/17/205 (only applicable to 2.6.24.x), that
| helped a lot as a deterministic way to bisect an issue that leaded to
| this fix.

 Just a small note. On 2.6.24.x this causes gdb to get unexpected
SIGTRAPs, which (for some reason) is easy to reproduce when debugging
C++/QT programs.

 And I have no idea on what kind of bug this is causing in latest
2.6.26 kernel.

-- 
Luiz Fernando N. Capitulino
