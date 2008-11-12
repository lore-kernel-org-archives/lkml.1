Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbYKLX5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbYKLX5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbYKLX5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:57:22 -0500
Received: from kroah.org ([198.145.64.141]:41239 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752245AbYKLX5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:57:22 -0500
Date: Wed, 12 Nov 2008 15:57:00 -0800
From: Greg KH <greg@kroah.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/wlan-ng: kill WLAN_CPU_FAMILY and WLAN_SYSARCH
Message-ID: <20081112235700.GB27554@kroah.com>
References: <1226500540-9667-1-git-send-email-vapier@gentoo.org> <20081112224628.GD27479@kroah.com> <8bd0f97a0811121536r4967b5ddh675a60216c1fb800@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0811121536r4967b5ddh675a60216c1fb800@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 06:36:57PM -0500, Mike Frysinger wrote:
> On Wed, Nov 12, 2008 at 17:46, Greg KH wrote:
> > On Wed, Nov 12, 2008 at 09:35:40AM -0500, Mike Frysinger wrote:
> >> The WLAN_CPU_FAMILY and WLAN_SYSARCH defines are used in all of three places
> >> (two of which look pretty suspect), so just kill them off rather than
> >> throwing up a pointless #error on processors that are not in the existing
> >> list.
> >
> > Thanks, but this is already cleaned up in my tree with a patch from
> > someone else.
> 
> where ?  i looked in staging.git and that hasnt been touched in 2 months.

It's at:
	http://kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-05-staging/

Sorry, I need to delete that old git tree, but it still contains a few
patches that haven't moved into the current tree for a variety of
reasons.

I've asked it to be picked up in the -next tree as well, so that will
also work for you.

thanks,

greg k-h
