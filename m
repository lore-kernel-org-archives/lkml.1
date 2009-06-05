Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbZFEW7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbZFEW7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 18:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZFEW7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 18:59:03 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:51685 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbZFEW7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 18:59:01 -0400
Date: Sat, 6 Jun 2009 01:01:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Sergei Poselenov <sposelenov@emcraft.com>
Cc: Wolfgang Denk <wd@denx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Re: 'make headers_check' failed to install headers to arbitrary location
Message-ID: <20090605230118.GU29008@uranus.ravnborg.org>
References: <4A0C3BFB.1010305@emcraft.com> <4A155B53.4040905@emcraft.com> <20090604175536.2a1d0add@emcraft.com> <20090604170715.98806832E416@gemini.denx.de> <20090605161109.50d4f253@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090605161109.50d4f253@emcraft.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 04:11:09PM +0400, Sergei Poselenov wrote:
> On Thu, 04 Jun 2009 19:07:15 +0200
> Dear Wolfgang,
> 
> Wolfgang Denk <wd@denx.de> wrote:
> 
> > Why not simply:
> > 
> > 	for f in $(all-files); do
> > 		echo "$(install)/$${f}"
> > 	done | xargs $(PERL) ...
> > 
> > ?
> > 
> 
> Ah,right, I missed this.
> 
> Here is the modified version of the patch, tested on 2.6.30-rc8,
> ARCH=arm
> 
> Subject: [PATCH] Fixed the "Argument list too long" error for "make headers_check",
>  used xargs to minimize the perl calls.
> 
> Signed-off-by: Sergei Poselenov <sposelenov@emcraft.com>

I extended the chagelog with the original error message
and applied this.

	Sam
