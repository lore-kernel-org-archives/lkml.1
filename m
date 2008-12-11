Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbYLKJo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbYLKJo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 04:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbYLKJoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 04:44:17 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:45181 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753924AbYLKJoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 04:44:16 -0500
Subject: Re: [PATCH 00/15] Kernel memory leak detector
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org
In-Reply-To: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 11 Dec 2008 09:44:08 +0000
Message-Id: <1228988648.332.5.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Dec 2008 09:44:10.0012 (UTC) FILETIME=[0469E5C0:01C95B75]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-10 at 18:26 +0000, Catalin Marinas wrote:
> A new kmemleak version is available. Thanks to all who reviewed the code
> and gave feedback. Kmemleak can also be found on this git tree:
> 
> git://linux-arm.org/linux-2.6.git kmemleak
[...]
> Changes since the previous release:

Something I forgot to mention here - I dropped the mem_map array
scanning since it doesn't work in all the kernel configurations and, as
Andrew Morton pointed out, it goes too deep into the kernel structures.
I didn't see any false positives on ARM but it may need more testing.

-- 
Catalin

