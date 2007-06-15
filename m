Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbXFONls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbXFONls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 09:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754969AbXFONlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 09:41:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48069 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781AbXFONli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 09:41:38 -0400
To: Christian Schmidt <lkml@digadd.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Help needed: Partitioned software raid > 2TB
References: <46727E7C.8060102@digadd.de>
From: Andi Kleen <andi@firstfloor.org>
Date: 15 Jun 2007 16:37:39 +0200
In-Reply-To: <46727E7C.8060102@digadd.de>
Message-ID: <p73d4zxs2q4.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Schmidt <lkml@digadd.de> writes:
> 
> Where is the inherent limit? The partitioning software, or partitioning
> all by itself?

DOS style partitioning don't support more than 2TB. You either need
to use EFI partitions (e.g. using parted) or LVM. Since parted's
user interface is not good for much more than serving
as a bad example I would recommend LVM.

-Andi
