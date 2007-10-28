Return-Path: <linux-kernel-owner+w=401wt.eu-S1753602AbXJ1WSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbXJ1WSq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 18:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbXJ1WSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 18:18:38 -0400
Received: from ic0245.upco.es ([130.206.70.245]:39650 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbXJ1WSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 18:18:37 -0400
Subject: Re: [PATCH] r8169: don't call napi_disable if not doing NAPI
From: Romano Giannetti <romanol@upcomillas.es>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Francois Romieu <romieu@fr.zoreil.com>,
       Jeff Garzik <jeff@garzik.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       Edward Hsu <edward_hsu@realtek.com.tw>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20071026113305.57dea765@freepuppy.rosehill>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
	 <1193232344.32208.0.camel@localhost> <20071024142759.GA13657@elte.hu>
	 <1193241191.14314.8.camel@localhost> <20071024155521.GA16690@elte.hu>
	 <1193242267.6914.6.camel@twins> <1193378269.17910.4.camel@localhost>
	 <20071026063733.GA12426@elte.hu>
	 <20071026094833.539a69aa@freepuppy.rosehill>
	 <20071026175613.GA18770@elte.hu>
	 <20071026113305.57dea765@freepuppy.rosehill>
Content-Type: text/plain; charset=ISO-8859-1
Date: Sun, 28 Oct 2007 23:18:29 +0100
Message-Id: <1193609909.9177.3.camel@rukbat>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-10-26 at 11:33 -0700, Stephen Hemminger wrote:
> Don't call napi_disable if not configured.
> And make sure that any misuse of napi_xxx in future fails
> with a compile error.

Will test as soon as possible (been without internet in the week end). 
Thanks.

As a bonus, I tried more thing, and I had a signal form lockdep. You can
find it here:

http://www.dea.icai.upcomillas.es/romano/linux/info/2624rc1_5/

patching and compiling now.

Romano 

-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
