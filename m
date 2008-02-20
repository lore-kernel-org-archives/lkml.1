Return-Path: <linux-kernel-owner+w=401wt.eu-S1765964AbYBTQ4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765964AbYBTQ4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:56:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760894AbYBTQzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:55:22 -0500
Received: from exprod7og108.obsmtp.com ([64.18.2.169]:48412 "EHLO
	exprod7og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759935AbYBTQzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:55:19 -0500
Date: Wed, 20 Feb 2008 16:55:13 +0000
From: Stephane Chazelas <stephane.chazelas@emerson.com>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2.6.24] block2mtd: removing a device and typo fixes
Message-ID: <chaz20080220165513.GU4539@artesyncp.com>
References: <chaz20080212134751.GI30304@artesyncp.com> <20080212152124.GA21878@lazybastard.org> <chaz20080212161034.GJ30304@artesyncp.com> <20080219150822.GA29587@lazybastard.org> <chaz20080220143646.GJ4539@artesyncp.com> <20080220164226.GF5539@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080220164226.GF5539@lazybastard.org>
Organization: Embedded Computing Emerson Network Power
X-URL: http://www.emersonembeddedcomputing.com
User-Agent: Mutt/1.5.16 (2007-09-19)
X-OriginalArrivalTime: 20 Feb 2008 16:55:14.0579 (UTC) FILETIME=[5D095E30:01C873E1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008-02-20 17:42:27 +0100, Jörn Engel:
> On Wed, 20 February 2008 14:36:46 +0000, Stephane Chazelas wrote:
> > 
> > At the moment, when we bind a mtd device to a block device, we
> > don't increase the refcount. When a mtdblock on a block2mtd, the
> > refcount is not increased either (the mtdblock's one is I
> > guess).
> 
> That is a bug then.
[...]

Well, given that there is no API to unbind a mtd to a block
device, otherwise, we would never be able to unload block2mtd.
So fare, unloading block2mtd was the only way to unbind a mtd
from a block device.

Cheers,
Stephane
