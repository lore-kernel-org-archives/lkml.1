Return-Path: <linux-kernel-owner+w=401wt.eu-S932375AbXC1CFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375AbXC1CFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 22:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933403AbXC1CFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 22:05:48 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:38580 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932375AbXC1CFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 22:05:47 -0400
Date: Wed, 28 Mar 2007 04:05:02 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: =?ISO-8859-2?Q?Pawe=B3_Sikora?= <pluto@agmk.net>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: smart gcc inliner...
In-Reply-To: <46093349.7060401@agmk.net>
Message-ID: <Pine.LNX.4.61.0703280401520.26461@yvahk01.tjqt.qr>
References: <46093349.7060401@agmk.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 27 2007 17:07, Paweł Sikora wrote:
>
> The recent gcc (3.4/4.x) optimizer inlines functions across
> sections which is definitely not we want, e.g. inlining
> functions from .init.text section.
>
> I think, the `__init' macro needs `noinline' attribute and all

An function from the .init section may very well inline a function from the
regular section, though.


Jan
-- 
