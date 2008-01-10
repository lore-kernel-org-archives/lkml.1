Return-Path: <linux-kernel-owner+w=401wt.eu-S1757866AbYAJOR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866AbYAJOR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 09:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbYAJORw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 09:17:52 -0500
Received: from twin.jikos.cz ([213.151.79.26]:48875 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbYAJORv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 09:17:51 -0500
Date: Thu, 10 Jan 2008 15:17:46 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: JustFillBug <mozbugbox@yahoo.com.au>
cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jerrold Jones <digireco@gmail.com>
Subject: Re: Why is "GoTop Super_Q2/GogoPen/PenPower tablets" treated as
 touchscreen?
In-Reply-To: <slrnfnvgnn.7sl.mozbugbox@mozbugbox.somehost.org>
Message-ID: <Pine.LNX.4.64.0801101517260.25041@twin.jikos.cz>
References: <slrnfnvgnn.7sl.mozbugbox@mozbugbox.somehost.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ added relevant CCs ]

On Sat, 5 Jan 2008, JustFillBug wrote:

> 
> In the commit:
> ===========
> author Jerrold Jones <digireco@gmail.com>
> Mon, 22 Oct 2007 04:59:47 +0000 (00:59 -0400)
> committer Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Mon, 22 Oct 2007 04:59:47 +0000 (00:59 -0400)
> committer Dmitry14e4020630b364cc564172a476cd6a6ac4bc7393
> tree 08c56cb99138275991993b62bb28ce3b92dee833 tree | snapshot
> parent 858711c55f757872b11574599bfa836df8ab34c9 commit | diff
> Input: usbtouchscreen - add support for GoTop tablet devices
> 
> Add support for GoTop Super_Q2/GogoPen/PenPower tablets to usbtouchscreen.
> Protocol discovery was done by Yick Yan Lam.
> ==========
> 
> The tablets were added as touchscreen devices instead of tablets. The
> tablets have some buttons while touch screen has no button. As a result,
> the buttons on the tablets will not function when treated as
> touchscreen.
> 
> Shouldn't the tablets be add to one of the device in the input/tablet/
> directory, like wacom, instead of input/touchscreen?
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Jiri Kosina
