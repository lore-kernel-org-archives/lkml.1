Return-Path: <linux-kernel-owner+w=401wt.eu-S1751601AbYLOMF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbYLOMF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 07:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750749AbYLOMFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 07:05:16 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55281 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbYLOMFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 07:05:15 -0500
Date: Mon, 15 Dec 2008 12:05:12 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Timo Sirainen <tss@iki.fi>
Cc: linux-kernel@vger.kernel.org, nuitari-dovecot@nuitari.net,
       Arno Wald <arno.wald@netcologne.de>,
       David Rosenstrauch <darose@darose.net>
Subject: Re: 2.6.27 inotify causes unkillable processes with 100% CPU usage
Message-ID: <20081215120512.GT28946@ZenIV.linux.org.uk>
References: <E459FC1E-BD45-459A-A9BD-AC682DBCD2D2@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E459FC1E-BD45-459A-A9BD-AC682DBCD2D2@iki.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2008 at 01:31:29PM +0200, Timo Sirainen wrote:
> There appears to be a bug in 2.6.27 and inotify where it causes processes 
> in running state to eat 100% CPU and they can't be killed with kill -9, 
> requiring a reboot to get rid of them.

> Kernels causing the hang:
>
> 2.6.27-9.slh.1-sidux-686
> Arch Linux, kernel 2.6.27.8
> Gentoo with 2.6.27-gentoo-r5, amd64, 2 dual core opterons
>
> Not causing the hang:
>
> 2.6.26-6.slh.1-sidux-686

Could you try to bisect that?  Particulary interesting commits:

8f7b0ba1c853919b85b54774775f567f30006107
6ff2d39b91aec3dcae951afa982059e3dd9b49dc
711a49a07f84f914aac26a52143f6e7526571143
