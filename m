Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbYKJKqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbYKJKqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 05:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbYKJKql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 05:46:41 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:60671 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbYKJKqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 05:46:40 -0500
Date: Mon, 10 Nov 2008 11:44:24 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
Message-ID: <20081110104423.GA26778@kernel.dk>
References: <4917263D.2090904@telenet.dn.ua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4917263D.2090904@telenet.dn.ua>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09 2008, Vitaly V. Bursov wrote:
> Hello,
> 
> I'm building small server system with openvz kernel and have ran into
> some IO performance problems. Reading a single file via NFS delivers
> around 9 MB/s over gigabit network, but while reading, say, 2 different
> or same file 2 times at the same time I get >60MB/s.
> 
> Changing IO scheduler to deadline or anticipatory fixes problem.
> 
> Tested kernels:
>   OpenVZ RHEL5 028stab059.3 (9 MB/s with HZ=100, 20MB/s with HZ=1000
>                  fast local reads)
>   Vanilla 2.6.27.5 (40 MB/s with HZ=100, slow local reads)
> 
> Vanilla performs better in worst case but I believe 40 is still low
> concerning test results below.

Can you check with this patch applied?

http://bugzilla.kernel.org/attachment.cgi?id=18473&action=view

-- 
Jens Axboe

