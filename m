Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbZLNOSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbZLNOSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 09:18:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757382AbZLNOSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 09:18:12 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:50296 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355AbZLNOSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 09:18:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=JJsMvpsLrsjHsYFwAoBEI+b6EC3FmZEDbQySenhe8XW+VIIMxXjD+HB373/JoSiSdB
         3Apfv3a1/8FHGDKyeCY7nSev+/UHGPZwY4drBH7dP7RLLaCPiu8Gaz077ALAtladwewj
         eDhm6R8ABOJPkZBA7eY4NY+8ddm9AHzayiIsE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: BFS v0.311 CPU scheduler for 2.6.32
Date: Mon, 14 Dec 2009 15:16:54 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Con Kolivas <kernel@kolivas.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200912111124.18118.kernel@kolivas.org> <200912121710.44216.kernel@kolivas.org> <20091212061447.GB2856@1wt.eu>
In-Reply-To: <20091212061447.GB2856@1wt.eu>
MIME-Version: 1.0
Message-Id: <200912141516.54725.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 December 2009 07:14:47 am Willy Tarreau wrote:
> On Sat, Dec 12, 2009 at 05:10:44PM +1100, Con Kolivas wrote:
> > > Also, I like to have the same kernel sources used on my desktop,
> > > notebook, eeepc, and my bootable USB key. It is a lot easier to
> > > upgrade and a lot easier to spot bugs before they strike in sensible
> > > environments.
> > 
> > Thanks Willy. 
> > 
> > That's the first meaningful reason I've heard for it. I may have to consider 
> > it now. It still would be compile time limited so probably not quite what 
> > you're hoping for. I don't have the time and energy to do and maintain the 
> > whole plugsched crap for boottime selection all over again, and that adds 
> > overhead which goes against one of my prime objectives.
> 
> No problem, as I said, I want to use the same *sources*, not to be able
> to hot-swap the scheduler. But basically I have a directory named "configs"
> in which all of my machines configs are stored. I run "build-kernel-list"
> over those configs from the kernel dir and I get all of my new kernels.
> You can now easily understand why I don't want to patch in the middle of
> the process :-)

Similar setup here and similar rationale behind my request. :)

I would like to give BFS a spin on some smaller boxes but then I would need
to remember to pull BFS out of my local patch queue whenever I want to test
something on my main box (I like to keep things rather conservative there)..

--
Bartlomiej Zolnierkiewicz
