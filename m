Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbYLSDZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbYLSDZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 22:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbYLSDZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 22:25:37 -0500
Received: from kroah.org ([198.145.64.141]:36952 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752297AbYLSDZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 22:25:37 -0500
Date: Thu, 18 Dec 2008 19:24:04 -0800
From: Greg KH <greg@kroah.com>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Eric Paris <eparis@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: kernel BUG at arch/x86/mm/ioremap.c:39 from
	2.6.28-rc8-next-20081218 on x86_64 vmware guest
Message-ID: <20081219032404.GA28379@kroah.com>
References: <1229622223.3374.9.camel@localhost.localdomain> <f19298770812181326g97be6d1x358723bb799a2854@mail.gmail.com> <f19298770812181856y44441d70k3b00aa346148f259@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f19298770812181856y44441d70k3b00aa346148f259@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 05:56:43AM +0300, Alexey Zaytsev wrote:
> The commit to blame was
> commit 33930cd1ccf6cf8c6124dc147d70641eb5d89a19
> Author: Greg Kroah-Hartman <gregkh@suse.de>
> Date:   Tue Dec 16 12:23:36 2008 -0800
> 
>     driver core: create a private portion of struct device
> 
>     This is to be used to move things out of struct device that no code
>     outside of the driver core should ever touch.
> 
>     Cc: Kay Sievers <kay.sievers@vrfy.org>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> 
> And an obvious fix:

<snip>

Thanks for the patch, was already fixed a few hours ago and will show up
in the next -next release :)

greg k-h
