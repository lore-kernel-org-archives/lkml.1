Return-Path: <linux-kernel-owner+w=401wt.eu-S1760587AbXGCP5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587AbXGCP5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbXGCP5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:57:15 -0400
Received: from mailhost.terra.es ([213.4.149.12]:15361 "EHLO
	csmtpout2.frontal.correo" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755806AbXGCP5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:57:14 -0400
Subject: Re: ppdev - libieee1284.so  conflicts with 2.6.21
From: Juan Antonio Martinez <jonsito@teleline.es>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <468986A7.5030402@redhat.com>
References: <1183368129.4967.1.camel@drake.micasa.es>
	 <20070702154753.56d06f10.akpm@linux-foundation.org>
	 <468986A7.5030402@redhat.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 03 Jul 2007 17:57:05 +0200
Message-Id: <1183478225.3006.31.camel@drake.micasa.es>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El lun, 02-07-2007 a las 19:13 -0400, Chuck Ebbert escribió:
> On 07/02/2007 06:47 PM, Andrew Morton wrote:
[...]
> > --- a/drivers/char/ppdev.c~a
> > +++ a/drivers/char/ppdev.c
> 
> He's reporting the bug against kernel 2.6.21, which does not have the
> patch you are reverting applied.
> 
> ppdev hasn't changed in the six months prior to 2.6.21...

Your'e right: seems that fedora kernel is based in 2.6.21-git5 and
latest changes in ppdev and parport layer starts at 2.6.21-git10. 
So need to look at other changes...

What does mean this report received in my working kernel?

"ppdev0: negotiated back to compatibility mode because user-space
forgot"

Juan Antonio

