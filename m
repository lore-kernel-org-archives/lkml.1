Return-Path: <linux-kernel-owner+w=401wt.eu-S1752954AbXFXQ1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbXFXQ1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 12:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbXFXQ1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 12:27:10 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4561 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbXFXQ1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 12:27:09 -0400
Date: Sun, 24 Jun 2007 18:27:25 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Wyatt Banks <wyatt@banksresearch.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HFSPlus: simplify inode mode settting logic
In-Reply-To: <467DACCA.7070002@banksresearch.com>
Message-ID: <Pine.LNX.4.64.0706241825230.1817@scrub.home>
References: <467DACCA.7070002@banksresearch.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 23 Jun 2007, Wyatt Banks wrote:

> Besides this redundancy, mode is the BSD file type and mode
> bits (see Apple TechNote 1150 for details) and is never 0.

This is wrong, there is an extra note:

"If the S_IFMT field (upper 4 bits) of the fileMode field is zero, then 
Mac OS X assumes that the permissions structure is uninitialized"

bye, Roman
