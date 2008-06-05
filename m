Return-Path: <linux-kernel-owner+w=401wt.eu-S1762942AbYFESum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762942AbYFESum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760255AbYFESt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:49:58 -0400
Received: from waste.org ([66.93.16.53]:55874 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756725AbYFESt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:49:57 -0400
Subject: Re: [PATCH 3/4] pagemap: Return EINVAL, not EIO, for unaligned
	reads of kpagecount or kpageflags (v2 of series)
From: Matt Mackall <mpm@selenic.com>
To: Thomas Tuttle <ttuttle@google.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <4ca0a85e0806051140r5985f6a4h42f12e60fe29050e@mail.gmail.com>
References: <4ca0a85e0806051140r5985f6a4h42f12e60fe29050e@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 13:49:17 -0500
Message-Id: <1212691757.3953.191.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-05 at 14:40 -0400, Thomas Tuttle wrote:
> If the user tries to read from a position that is not a multiple of 8, or
> read a number of bytes that is not a multiple of 8, they have passed an
> invalid argument to read, for the purpose of reading these files.  It's
> not an IO error because we didn't encounter any trouble finding the data
> they asked for.

Hmm. I seem to recall choosing EIO because that's what unaligned reads
with direct I/O report. I don't particularly care though.

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.

