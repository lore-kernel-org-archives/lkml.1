Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab0BOUOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 15:14:17 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:35193 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448Ab0BOUOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 15:14:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gv0wrnsysVIKxvzErm6VjcBrlUoMOimQL7a38vSjF+n9mgsH0vHaOnpjxIC5tm1faA
         ssgIu7YnnCCft7eDOPs2kJFW5JveO1r8aR+IyzHpW+y9goMYijQLmdVIyl2eYm24JTZS
         hHVu571JVmO6ZaZ7dMkmyDGVXxGQTUYO7Rclc=
Date: Mon, 15 Feb 2010 21:12:01 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       nouveau@lists.freedesktop.org, Maarten Maathuis <madman2003@gmail.com>
Subject: Re: [git pull] drm
Message-ID: <20100215201201.GA3332@joi.lan>
References: <alpine.DEB.2.00.1002110417200.516@skynet.skynet.ie>
 <201002151053.48681.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002151053.48681.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 10:53:48AM +0100, Christian Borntraeger wrote:
> Am Donnerstag 11 Februar 2010 05:20:07 schrieb Dave Airlie:
> 
> Dave,
> 
> I just updated from to rc8 and got the a scheduling while atomic warning in
> nouveau. (see below).

Linus' tree is missing two fixes:

drm/nouveau: don't hold spin lock while calling kzalloc with GFP_KERNEL
drm/nouveau: spin_lock_init after memset'ing the bios struct

The first one fixes your bug.

http://cgit.freedesktop.org/nouveau/linux-2.6/commit/?id=ed64797d153ecf0da79b8b849642d7a109fd97fd
http://cgit.freedesktop.org/nouveau/linux-2.6/commit/?id=9da76700072a00c39e21553df0998c7b3b620d88

If they won't go into 2.6.33, they are perfect candidates for -stable.

Marcin
