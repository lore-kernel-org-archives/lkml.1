Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbZAaByz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbZAaByz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 20:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbZAaByn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 20:54:43 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:13448 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbZAaByn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 20:54:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=ODZegbg7CHZAgTClAFAgXf75lm0thTE0deL/1hjtmca8nxTQnYQmEqQkMHfjt2t8Aw
         2ODf+JfU3bjyReCq2aZ6uVouAFl70QHMGh5seID4rYvIf86i2OVvxF2PzQeY/kDecFsK
         xvGSfOlTNJtO4Gn6uuxv51dHpMK8EdCQtrwbM=
Date: Fri, 30 Jan 2009 20:54:38 -0500 (EST)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-desktop
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Parag Warudkar <parag.lkml@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matt Carlson <mcarlson@broadcom.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.29-rc3: tg3 dead after resume
In-Reply-To: <alpine.LFD.2.00.0901301741380.3150@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0901302051390.5643@parag-desktop>
References: <alpine.DEB.2.00.0901281858380.5048@parag-desktop> <200901310059.17746.rjw@sisk.pl> <alpine.DEB.2.00.0901301924550.5056@parag-desktop> <200901310138.51214.rjw@sisk.pl> <alpine.DEB.2.00.0901302016170.5643@parag-desktop>
 <alpine.LFD.2.00.0901301741380.3150@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 Jan 2009, Linus Torvalds wrote:

> 
> 
> On Fri, 30 Jan 2009, Parag Warudkar wrote:
> > 
> > Excellent! This patch works - tg3 comes back and gets link after resume.
> 
> I still think the patch isn't very good. See my previous email. 

Ok - I will run with it temporarily and will do what I can to track down 
what was wrong with the legacy PM.

Thanks!
Parag

