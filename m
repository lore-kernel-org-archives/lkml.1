Return-Path: <linux-kernel-owner+w=401wt.eu-S1764967AbXGNVNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764967AbXGNVNR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 17:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757645AbXGNVNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 17:13:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36767 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757616AbXGNVNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 17:13:07 -0400
Message-ID: <46993C59.1030902@zytor.com>
Date: Sat, 14 Jul 2007 14:12:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Olaf Hering <olaf@aepfle.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove PAGE_SIZE from headers_install
References: <20070714205709.GA9478@aepfle.de>
In-Reply-To: <20070714205709.GA9478@aepfle.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Hering wrote:
> Declare PAGE_SIZE as getpagesize() for userspace.
> PAGE_SIZE is used in resource.h and shm.h

I would think it would be better to not define it at all.  Several
architectures already don't have PAGE_SIZE visible to userspace in any way.

	-hpa
