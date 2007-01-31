Return-Path: <linux-kernel-owner+w=401wt.eu-S932500AbXAaDEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500AbXAaDEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932516AbXAaDEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:04:09 -0500
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:41420 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500AbXAaDEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:04:08 -0500
Date: Tue, 30 Jan 2007 22:03:40 -0500
From: Kyle McMartin <kyle@parisc-linux.org>
To: Zwane Mwaikambo <zwane@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] AGPGART compat ioctl
Message-ID: <20070131030340.GB7088@athena.road.mcmartin.ca>
References: <Pine.LNX.4.64.0701271403420.1379@montezuma.fsmlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701271403420.1379@montezuma.fsmlabs.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 27, 2007 at 07:28:07PM -0800, Zwane Mwaikambo wrote:
> Hi Dave,
> 	The following video card requires the agpgart driver ioctl 
> interface in order to detect video memory.
> 

Tested with testgart.c on parisc64, seems to work alright. Thanks for
doing this work, Zwane. I've been meaning to do compat_ioctl for
agpgart for months.

Cheers,
	Kyle M.
