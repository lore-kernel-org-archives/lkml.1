Return-Path: <linux-kernel-owner+w=401wt.eu-S1760998AbYDVREW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760998AbYDVREW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbYDVREO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:04:14 -0400
Received: from brick.kernel.dk ([87.55.233.238]:20756 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbYDVREN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:04:13 -0400
Date: Tue, 22 Apr 2008 19:04:06 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
Message-ID: <20080422170405.GO12774@kernel.dk>
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <1208851058-8500-2-git-send-email-jens.axboe@oracle.com> <alpine.LFD.1.10.0804220735350.2779@woody.linux-foundation.org> <20080422145105.GJ12774@kernel.dk> <alpine.LFD.1.10.0804220759020.2779@woody.linux-foundation.org> <20080422164947.GN12774@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422164947.GN12774@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22 2008, Jens Axboe wrote:
> +		data = kmalloc(sizeof(*data), GFP_ATOMIC);
> +		if (!unlikely(!data)) {

Woops. I'll test everything and send out the full series, at least the
intention should have been clear.

-- 
Jens Axboe

