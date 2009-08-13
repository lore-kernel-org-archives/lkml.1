Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbZHNAEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbZHNAEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 20:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbZHNAEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 20:04:41 -0400
Received: from kroah.org ([198.145.64.141]:36400 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbZHNAEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 20:04:40 -0400
Date: Thu, 13 Aug 2009 16:44:10 -0700
From: Greg KH <greg@kroah.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Lothar Wassmann <LW@karo-electronics.de>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] USB: isp1362: fix build warnings on 64-bit systems
Message-ID: <20090813234410.GB4406@kroah.com>
References: <1250046053-3097-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250046053-3097-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 11:00:53PM -0400, Mike Frysinger wrote:
> A bunch of places assumed pointers were 32-bits in size (bit checking and
> debug output), but none of these affected runtime functionality.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

This patch doesn't apply to my tree, what did you make it against?

thanks,

greg k-h
