Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbYBAKza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbYBAKza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 05:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbYBAKzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 05:55:19 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49100 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757359AbYBAKzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 05:55:17 -0500
Date: Fri, 1 Feb 2008 04:55:16 -0600
From: Robin Holt <holt@sgi.com>
To: Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 1/4] mmu_notifier: Core code
Message-ID: <20080201105516.GK26420@sgi.com>
References: <20080201050439.009441434@sgi.com> <20080201050623.112641539@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201050623.112641539@sgi.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK.  Now that release has been moved, I think I agree with you that the
down_write(mmap_sem) can be used as our lock again and still work for
Jack.  I would like a ruling from Jack as well.

Thanks,
Robin
