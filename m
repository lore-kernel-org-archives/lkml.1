Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbYKMVN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbYKMVN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 16:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbYKMVNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 16:13:18 -0500
Received: from gv-out-0910.google.com ([216.239.58.191]:41005 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbYKMVNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 16:13:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=XY/4Th06VkzSZpxXLtMF+F9GPgx+xC04elAiy05jQjlN2DWT3JnUYb+fz4criG/sVq
         z4cuoCCzp8F9m59Y181jSbTKB/SXGmOYWGWSfh4Ed8yy8p9w/XX38HRfTD+fF1pEqWQ2
         oniOmyZa5EDGeIw80gTAS9qW9KJSy4CIr7XsQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: Missing CONFIG_IDE_LEGACY definition (Re: linux-next: Tree for November 13)
Date: Thu, 13 Nov 2008 22:08:42 +0100
User-Agent: KMail/1.9.10
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <20081113183316.3601c13d.sfr@canb.auug.org.au> <s5hiqqsq9pv.wl%tiwai@suse.de>
In-Reply-To: <s5hiqqsq9pv.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811132208.43694.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 November 2008, Takashi Iwai wrote:
> At Thu, 13 Nov 2008 18:33:16 +1100,
> Stephen Rothwell wrote:
> > 
> > Hi all,
> > 
> > Changes since 20081112:
> > 
> > Undropped tree:
> > 	security-testing
> > 
> > Dropped trees (temporarily):
> > 	sh (build problems)
> > 	creds (non-trivial conflict)
> > 	userns (it depends on creds)
> > 	semaphore-removal (due to unfixed conflicts against Linus' tree)
> > 	firmware (unfixed build failure)
> > 
> > The usb tree lost its conflict.
> > 
> > The net tree lost its 3 conflicts.
> 
> The IDE tree update seems broken for some old devices.
> CONFIG_IDE_LEGACY is selected by them but it's nowhere defined in
> Kconfig.

Thanks for noticing and fixing this.

I've integrated your fix into the guilty patch ("ide: move legacy
ISA/VLB ports handling to ide-legacy.c") to preserve bisectability.

Bart
