Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbZEINZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbZEINZj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 09:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbZEINZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 09:25:30 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:5223 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbZEINZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 09:25:29 -0400
Date: Sat, 9 May 2009 15:25:14 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Greg KH <gregkh@suse.de>
Cc: Ming Lei <tom.leiming@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver core: Silent meaningless error message
Message-ID: <20090509152514.6f2207bc@hyperion.delvare>
In-Reply-To: <20090501151435.GB16106@suse.de>
References: <20090501145151.5f97456e@hyperion.delvare>
	<20090501151435.GB16106@suse.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Fri, 1 May 2009 08:14:35 -0700, Greg KH wrote:
> On Fri, May 01, 2009 at 02:51:51PM +0200, Jean Delvare wrote:
> > I see the following error message in my kernel logs:
> > 
> > w83627ehf.2576: use which platform_data?
> > 
> > This is caused by platform_device_add_data() setting both
> > pdev->platform_data and pdev->dev.platform_data, and then
> > platform_device_add() complaining if both pointers are set.
> > 
> 
> The patch that causes this is about to be reverted later today (it's
> already reverted in my trees), as it was the wrong thing to do, as you
> point out.
> 
> So this should be solved soon, no need for your patch.

Any news on this? I can't see any fix in kernel 2.6.30-rc5.

-- 
Jean Delvare
