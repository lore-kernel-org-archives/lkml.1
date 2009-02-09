Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbZBINMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbZBINMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbZBINMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:12:21 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:43091 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754084AbZBINMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:12:19 -0500
Subject: Re: mm_alloc()'ed structure leak
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1234181898.16083.26.camel@pc1117.cambridge.arm.com>
References: <1234181898.16083.26.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 09 Feb 2009 13:12:04 +0000
Message-Id: <1234185124.16083.28.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2009 13:12:09.0590 (UTC) FILETIME=[039B6160:01C98AB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-09 at 12:18 +0000, Catalin Marinas wrote:
> I've noticed on recent kernels (currently 2.6.29-rc3) a memory leak
> reported by kmemleak for an mm_struct allocated in mm_alloc().

FYI, I tried 2.6.29-rc4 and the leak is still present.

-- 
Catalin

