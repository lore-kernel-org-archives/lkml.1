Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbXLBRqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbXLBRqR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 12:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbXLBRqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 12:46:05 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53870 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752484AbXLBRqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 12:46:04 -0500
Message-Id: <1196617561.16481.1224371239@webmail.messagingengine.com>
X-Sasl-Enc: Jyzyex4qX4B10prZ0xDt6R0mStUwm3vpvx6onUaCsHKQ 1196617561
From: "Thomas Tuttle" <linux-kernel@ttuttle.net>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1196196237.19410.1223544787@webmail.messagingengine.com>   
   <20071202164316.GB7377@cvg>
Subject: Re: Oops with 2.6.24 git when loading iwl3945
In-Reply-To: <20071202164316.GB7377@cvg>
Date: Sun, 02 Dec 2007 12:46:01 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Dec 2007 19:43:16 +0300, "Cyrill Gorcunov"
<gorcunov@gmail.com> said:
> [Thomas Tuttle - Tue, Nov 27, 2007 at 03:43:57PM -0500]
> | Hey.
> | 
> | I'm using a git snapshot that gentoo distributed mere hours ago (so I'm
> | fairly confident it's current), and I'm getting an Oops when I try to
> | load the iwl3945 driver.  I've attached it as plain text.
> | 
> | Hope this helps,
> | 
> | Thomas Tuttle
> 
> Hi Thomas,
> Could you please test the patch?

It didn't help.  The original oops says the problem was in strcmp.  It
was a GPF, which suggests to me that one of the arguments is NULL. 
Since ops->name is checked at the beginning of the function, the only
other possibility is that alg->ops->name is NULL.  I added a bit of code
to check for this, and it turns out that one of the strings was indeed
NULL.  I didn't know where to go from there in debugging, but I hope it
helps.

Thanks,

Thomas Tuttle
