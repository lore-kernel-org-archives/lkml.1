Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbZBFQDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbZBFQDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 11:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759219AbZBFQDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 11:03:10 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:43678 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752376AbZBFQDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 11:03:09 -0500
Subject: Re: next-20090202: task kmemleak:763 blocked for more than
	120seconds.
From: Catalin Marinas <catalin.marinas@arm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mandeep Singh Baines <msb@google.com>,
       Alexander Beregalov <a.beregalov@gmail.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090203205204.GC6344@nowhere>
References: <20090203205204.GC6344@nowhere>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 06 Feb 2009 16:02:58 +0000
Message-Id: <1233936178.10555.16.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Feb 2009 16:03:02.0720 (UTC) FILETIME=[63B59C00:01C98874]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 20:52 +0000, Frederic Weisbecker wrote:
> Note that requiring kmemleak to be freezable looks only relevant if it does
> some memory allocations (hibernation needs some memory and prefer that there
> are not too much parallel memory allocations.)

OK. In this case, there is no need for the kmemleak thread to be
freezable. It only scans the memory periodically but doesn't allocate
any itself.

Thanks.

-- 
Catalin

