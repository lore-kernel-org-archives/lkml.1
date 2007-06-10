Return-Path: <linux-kernel-owner+w=401wt.eu-S1762230AbXFJEvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762230AbXFJEvE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 00:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756909AbXFJEux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 00:50:53 -0400
Received: from holomorphy.com ([66.93.40.71]:47277 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756869AbXFJEux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 00:50:53 -0400
Date: Sat, 9 Jun 2007 21:51:45 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: dean gaudet <dean@arctic.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Adam Litke <agl@us.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.21 numa policy and huge pages not working
Message-ID: <20070610045145.GA6909@holomorphy.com>
References: <Pine.LNX.4.64.0705152222550.14691@twinlark.arctic.org> <20070516061259.GZ19966@holomorphy.com> <Pine.LNX.4.64.0706092106220.10324@twinlark.arctic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706092106220.10324@twinlark.arctic.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2007 at 09:10:51PM -0700, dean gaudet wrote:
> ok i've narrowed it some... maybe.
> in commit 8ef8286689c6b5bc76212437b85bdd2ba749ee44 things work fine, numa 
> policy is respected...
> the very next commit bc56bba8f31bd99f350a5ebfd43d50f411b620c7 breaks shm 
> badly causing the test program to oops the kernel.
> commit 516dffdcd8827a40532798602830dfcfc672294c fixes that breakage but 
> numa policy is no longer respected.
> i've added the authors of those two commits to the recipient list and 
> reattached the test program.  hopefully someone can shed light on the 
> problem.

Thanks, this helps a lot.


-- wli
