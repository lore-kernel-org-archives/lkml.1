Return-Path: <linux-kernel-owner+w=401wt.eu-S1760518AbYFEQZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760518AbYFEQZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbYFEQZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:25:42 -0400
Received: from waste.org ([66.93.16.53]:45269 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629AbYFEQZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:25:41 -0400
Subject: Re: [PATCH 4/5] pagemap: Make /proc/kpage{count,flags} return
	EINVAL (not EIO) on unaligned read.
From: Matt Mackall <mpm@selenic.com>
To: Thomas Tuttle <ttuttle@google.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <4ca0a85e0806050807v1ad0c309y75badc3fff7b796f@mail.gmail.com>
References: <4ca0a85e0806050807v1ad0c309y75badc3fff7b796f@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 11:24:46 -0500
Message-Id: <1212683087.3953.184.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-05 at 11:07 -0400, Thomas Tuttle wrote:
> If a process tries to read at a position that's not a multiple of 8,
> or for a count that's not a multiple of 8, they've passed an invalid
> argument to read (for this file), so we should return EINVAL.

This patch should probably precede your 3/5.

-- 
Mathematics is the supreme nostalgia of our time.

