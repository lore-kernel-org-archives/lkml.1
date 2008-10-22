Return-Path: <linux-kernel-owner+w=401wt.eu-S1759144AbYJVS4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759144AbYJVS4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756964AbYJVSwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:52:20 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:59001 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758350AbYJVSwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:52:19 -0400
X-Greylist: delayed 678 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2008 14:52:18 EDT
X-RZG-CLASS-ID: mo05
X-RZG-AUTH: :Pm0FVUW6aauhRGJJc5OfA4AU8DM8ZlijdmJYxKn/UQvEQQx8Ak89p3I=
Date: Wed, 22 Oct 2008 20:40:58 +0200
From: Alex Riesen <fork0@users.sourceforge.net>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       em28xx@mcentral.de
Subject: Re: [PATCH] em28xx patches against the latest git tree
Message-ID: <20081022184058.GB4626@blimp.localdomain>
Reply-To: Alex Riesen <fork0@users.sourceforge.net>
References: <d9def9db0810221034v3bf4dabt6aa905b8a3ebd5a@mail.gmail.com> <d9def9db0810221038g156871e1u200abb90b774ad28@mail.gmail.com> <81b0412b0810221059w2e02b1c1ubd894b22f7991242@mail.gmail.com> <d9def9db0810221110g6f104b17g36a74704d43c5693@mail.gmail.com> <20081022182924.GA4626@blimp.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022182924.GA4626@blimp.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Riesen, Wed, Oct 22, 2008 20:29:24 +0200:
> Markus Rechberger, Wed, Oct 22, 2008 20:10:49 +0200:
> > On Wed, Oct 22, 2008 at 7:59 PM, Alex Riesen <raa.lkml@gmail.com> wrote:
> > > 2008/10/22 Markus Rechberger <mrechberger@gmail.com>:
> > >>> commit history is available at:
> > >> http://mcentral.de/hg/~mrec/em28xx-new/shortlog
> > >>
> > The [old] driver has a long and rather bad history, which I'd like to avoid
> > by using the different directory.
> 
> You could submit patches depricating it. Does the old driver support
> something yours does not?
> 

BTW, you forgot to a patch to include your driver into Kconfig of
drivers/media/video. Something like this, perhaps:

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 47102c2..1bbee59 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -781,7 +781,7 @@ source "drivers/media/video/gspca/Kconfig"
 
 source "drivers/media/video/pvrusb2/Kconfig"
 
-source "drivers/media/video/em28xx/Kconfig"
+source "drivers/media/video/empia/Kconfig"
 
 source "drivers/media/video/usbvision/Kconfig"
 
