Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbXJ2I44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbXJ2I44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 04:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbXJ2I4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 04:56:46 -0400
Received: from ic0245.upco.es ([130.206.70.245]:42485 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbXJ2I4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 04:56:45 -0400
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
Content-Type: text/plain; charset=utf-8
Date: Mon, 29 Oct 2007 09:56:42 +0100
Message-Id: <1193648202.15743.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-10-26 at 11:33 -0700, Stephen Hemminger wrote:
> Don't call napi_disable if not configured.
> And make sure that any misuse of napi_xxx in future fails
> with a compile error.
> 
> Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
> 

This fix the problem for me (at least, after 8 suspend/resume cycles). 
Thanks.

Tested-by: Romano Giannetti <romano.giannetti@gmail.com>

-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
