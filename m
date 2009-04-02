Return-Path: <linux-kernel-owner+w=401wt.eu-S1762315AbZDBPZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762315AbZDBPZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbZDBPZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 11:25:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42794 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760951AbZDBPZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 11:25:18 -0400
Date: Thu, 2 Apr 2009 17:25:03 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Chris Wright <chrisw@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, riel@redhat.com, jeremy@goop.org, mtosatti@redhat.com,
       hugh@veritas.com, corbet@lwn.net, yaniv@redhat.com,
       dmonakhov@openvz.org
Subject: Re: [PATCH 5/4] update ksm userspace interfaces
Message-ID: <20090402152503.GI9137@random.random>
References: <49D23224.9000903@codemonkey.ws> <20090331151845.GT9137@random.random> <49D23CD1.9090208@codemonkey.ws> <20090331162525.GU9137@random.random> <49D24A02.6070000@codemonkey.ws> <20090402012215.GE1117@x200.localdomain> <49D424AF.3090806@codemonkey.ws> <20090402053114.GF1117@x200.localdomain> <20090402144118.GH9137@random.random> <20090402151251.GA10392@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402151251.GA10392@x200.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 08:12:51AM -0700, Chris Wright wrote:
> less regardless of the vma).  To do it purely at the vma level would
> mean a vma unmap would cause the watch to go away.  So, question is...do

But madvise effects must go away at munmap/mmap-overwrite...
