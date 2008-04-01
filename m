Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbYDAJDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbYDAJDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 05:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757044AbYDAJD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 05:03:29 -0400
Received: from lazybastard.de ([212.112.238.170]:58297 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757020AbYDAJD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 05:03:28 -0400
Date: Tue, 1 Apr 2008 11:03:09 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Artem Bityutskiy <dedekind@yandex.ru>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>,
       penberg@cs.helsinki.fi, ext-adrian.hunter@nokia.com, jwboyer@gmail.com
Subject: Re: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
Message-ID: <20080401090309.GA7465@logfs.org>
References: <47F1EC20.6050600@wpkg.org> <47F1F644.4060000@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47F1F644.4060000@yandex.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 April 2008 11:45:56 +0300, Artem Bityutskiy wrote:
> Tomasz Chmielewski wrote:
> >For me, the motivators to wait for LogFS are mainly the facts that it
> >can work on traditional block devices, and not only on pure flash:
> 
> Sorry Thomasz, for me this makes zero sense. There are _much_ better file
> systems for block devices. UBIFS may work on top of a block device as
> well (just needs few hacks to make it possible) - it is not a problem
> at all, it is just _senseless_.
> 
> JFFS2/UBIFS/LogFS is a separate _class_ of file-systems. The are designed
> for _flash_, which has completely different work model then block device.
> They are _native_ flash file systems.
> Here are more details: 
> http://www.linux-mtd.infradead.org/faq/general.html#L_mtd_vs_hdd
> 
> The traditional FSes _cannot_ work on top of flash. The solution for this
> is using FTL, which emulates a block device on top of flash. It _hides_ the
> real device, and fakes a block device for you. And you can use traditional
> FSes on top of that fake block device.
> 
> The whole _point_ of this separate class of FSes is because we believe
> we may do much _better_ job if we use flash _natively_, instead of using
> FTL. FTL is the place where you loose performance, reliability, and so on.
> 
> And you are saying about using a native flash FS on top of a block device
> like an SD card. This is just not sane: SD card first emulates a block 
> device
> for you, looses performance at this point, then you again emulate a flash
> on top of this, and suffer from this again.

About a year ago I would have used roughly the same argument.  But in
the meanwhile I have accepted the fact that any piece of flash I'll use
in a notebook in the next five years will likely use SATA or USB as a
transport medium.

Jörn

-- 
...one more straw can't possibly matter...
-- Kirby Bakken
