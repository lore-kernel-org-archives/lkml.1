Return-Path: <linux-kernel-owner+w=401wt.eu-S933690AbYBTQnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933690AbYBTQnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:43:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757029AbYBTQm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:42:56 -0500
Received: from lazybastard.de ([212.112.238.170]:52263 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759068AbYBTQmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:42:55 -0500
Date: Wed, 20 Feb 2008 17:42:27 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Stephane Chazelas <stephane.chazelas@emerson.com>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2.6.24] block2mtd: removing a device and typo fixes
Message-ID: <20080220164226.GF5539@lazybastard.org>
References: <chaz20080212134751.GI30304@artesyncp.com> <20080212152124.GA21878@lazybastard.org> <chaz20080212161034.GJ30304@artesyncp.com> <20080219150822.GA29587@lazybastard.org> <chaz20080220143646.GJ4539@artesyncp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <chaz20080220143646.GJ4539@artesyncp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 February 2008 14:36:46 +0000, Stephane Chazelas wrote:
> 
> At the moment, when we bind a mtd device to a block device, we
> don't increase the refcount. When a mtdblock on a block2mtd, the
> refcount is not increased either (the mtdblock's one is I
> guess).

That is a bug then.

Jörn

-- 
The story so far:
In the beginning the Universe was created.  This has made a lot
of people very angry and been widely regarded as a bad move.
-- Douglas Adams
