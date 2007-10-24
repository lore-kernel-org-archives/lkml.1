Return-Path: <linux-kernel-owner+w=401wt.eu-S1756417AbXJXPxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417AbXJXPxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 11:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbXJXPxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 11:53:14 -0400
Received: from antispam.upcomillas.es ([130.206.70.245]:58074 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbXJXPxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 11:53:14 -0400
Subject: Re: 2.6.24-rc1 fails with lockup and BUG:
From: Romano Giannetti <romanol@upcomillas.es>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20071024142759.GA13657@elte.hu>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
	 <1193232344.32208.0.camel@localhost>  <20071024142759.GA13657@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Date: Wed, 24 Oct 2007 17:53:11 +0200
Message-Id: <1193241191.14314.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-10-24 at 16:27 +0200, Ingo Molnar wrote:

> 
>   CONFIG_PROVE_LOCKING=y
>   CONFIG_DEBUG_LIST=y
>   CONFIG_FRAME_POINTER=y
>   CONFIG_DEBUG_SLAB=y
> 
> and please post the resulting dmesg output - does lockdep notice any 
> lockup reason? (your backtrace suggests some mutex stuff so it might as 
> well detect it)
> 

Done. The results are at: 

http://www.dea.icai.upcomillas.es/romano/linux/info/2624rc1_2/

in the  syslog-after-failed-suspend.txt file. After the failed suspend
(at line 15766) there where the bunch of things in D-state. I have left
the file intact.

At line 17646 there  is:

WARNING: at kernel/lockdep.c:2033 trace_hardirqs_on() 

I waited a bit and then, on an already-opened root shell, did 
s2ram -f -p -m  (line 17811)

and then a lot more things happened, and I am somewhat lost.

Hope this could be useful to you.

Romano 

-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
