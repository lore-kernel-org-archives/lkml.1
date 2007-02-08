Return-Path: <linux-kernel-owner+w=401wt.eu-S1752440AbXBHSqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbXBHSqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 13:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbXBHSqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 13:46:30 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:54539 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423243AbXBHSq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 13:46:29 -0500
Date: Thu, 8 Feb 2007 19:46:13 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Alex Bounder <abounder@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: creating headless device on 2.6.18
In-Reply-To: <8474209b0702081005t196c64bajbf94f119e4ed32e@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0702081944230.1364@yvahk01.tjqt.qr>
References: <8474209b0702081005t196c64bajbf94f119e4ed32e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 8 2007 20:05, Alex Bounder wrote:
> Hello, all.
> I'm trying to create a headless device based on kernel 2.6.18 (FEDORA
> distro). What I need is to guarantee that LINUX kernel do not access
> the graphical adapter (used by another OS).
> My idea was to remove from .config everything that is graphic related.
> Yet there are two flags, which are "irremovable". These are
> :CONFIG_VGA_CONSOLE and CONFIG_VIDEO_V4L2. The only option for them is
> [y]. Can anyone help me to get rid of them or suggest another way of
> "blocking" the graphical adapter?

V4L2 is something different. Turn on EMBEDDED, then you should be able to
deactivate VGA_CONSOLE.


Jan
-- 
