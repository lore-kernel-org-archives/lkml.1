Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbZDNOKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbZDNOKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 10:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbZDNOKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 10:10:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48500 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbZDNOKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 10:10:39 -0400
To: anton@mips.complang.tuwien.ac.at
Cc: linux-kernel@vger.kernel.org
Subject: Re: Out-of-order writing by disk drives
From: Andi Kleen <andi@firstfloor.org>
References: <E1LrHX3-0003u5-2G@a4.complang.tuwien.ac.at>
Date: Tue, 14 Apr 2009 16:10:34 +0200
In-Reply-To: <E1LrHX3-0003u5-2G@a4.complang.tuwien.ac.at> (Anton Ertl's message of "Tue, 7 Apr 2009 22:04:29 +0200 (CEST)")
Message-ID: <87r5zv72cl.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Anton Ertl" <anton@mips.complang.tuwien.ac.at> writes:
>
> /dev/md2        /home           ext3    defaults,barrier=1      1	2

Just make sure /dev/md2 is a RAID1, MD RAID0/5/10 don't support barriers.

See also my general treatise of multiple device barriers earlier today.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
