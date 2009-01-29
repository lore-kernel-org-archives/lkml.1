Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbZA2Gka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbZA2Gka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 01:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbZA2GkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 01:40:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57373 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZA2GkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 01:40:20 -0500
Message-ID: <49814E89.6090802@zytor.com>
Date: Wed, 28 Jan 2009 22:36:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86: unify asm/io.h: IO_SPACE_LIMIT
References: <4980ED5F.30904@goop.org>
In-Reply-To: <4980ED5F.30904@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,

I applied patch #1 to tip:x86/cleanups, however, patch #2 and #3 are
identical... did you mean to do something different here?

Furthermore, please provide an actual description (and preferrably an
Impact: line) with your patches.  In particular, when unifying code that
is identical between 32 and 64 bits, please specify this in the
description (e.g. "unified functions X and Y which were already
identical between 32 and 64 bits"), so we know why there isn't a
preceeding patch to remove the remaining differences.

Thanks,

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

