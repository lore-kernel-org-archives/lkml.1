Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbZLDPej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbZLDPej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 10:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbZLDPei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 10:34:38 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49791 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403AbZLDPei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 10:34:38 -0500
Date: Fri, 4 Dec 2009 16:34:43 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Louis Rilling <louis.rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] block: io_context refcount fixes
Message-ID: <20091204153443.GH8742@kernel.dk>
References: <1259934762-16920-1-git-send-email-louis.rilling@kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259934762-16920-1-git-send-email-louis.rilling@kerlabs.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04 2009, Louis Rilling wrote:
> 
> Hi,
> 
> When reading copy_io() I found probable refcounting issues with shared
> io_context. IIUC, the following two patches could fix those issues.
> If I am correct, then those fixes should go to stable too.
> 
> Based on v2.6.32 and compile-tested only.

Thanks, those both look correct. I will apply them, but please also do
whatever testing that caused you to find this in the first place (or was
it code inspection)?

-- 
Jens Axboe

