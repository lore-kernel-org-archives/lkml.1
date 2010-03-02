Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab0CBNwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 08:52:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56646 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab0CBNwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 08:52:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Paul <abnominales@web.de>
Subject: Re: yaffs2 NAND fs
Date: Tue, 2 Mar 2010 14:51:59 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1267506354.1618.4.camel@virtubuntu>
In-Reply-To: <1267506354.1618.4.camel@virtubuntu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003021451.59773.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/303M6BJZYTZwa9iS9aqJ76KsTz6PbKvDdw13
 OuEJqJRZkoS9V65Lhh1bRs9cVQGCauyIf/AjZaI+YrZyIqCo0p
 bIRWAxtgZTw5PxiYUX8DQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 March 2010, Peter Paul wrote:
> I was wondering why the yaffs2 file system has not gone for mainline
> yet. It's rather popular flash file system in the embedded world, while
> it is rather easy to patch a kernel to have yaffs2 support [1] it would
> be even nicer if it was just in mainline.
> The source of the GPLv2 file system can be found at [2]
> 
> [1] http://www.yaffs.net/howto-incorporate-yaffs 
> [2] http://www.aleph1.co.uk/cgi-bin/viewcvs.cgi/yaffs2/

I would guess it's a combination of multiple reasons:

1. It has not been submitted for upstream inclusion, at least not
   during the last few years.
2. We don't have a staging area like drivers/staging for file systems
   in the way that we have for drivers
3. There is now ubifs and (soon) logfs upstream, both of which appear
   to be superior to yaffs in many ways.

	Arnd
