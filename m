Return-Path: <linux-kernel-owner+w=401wt.eu-S1755614AbYEOPWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbYEOPWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 11:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbYEOPW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 11:22:27 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:36249 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbYEOPW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 11:22:26 -0400
Date: Thu, 15 May 2008 09:22:10 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove argument from open_softirq which is always NULL
Message-ID: <20080515152210.GL9921@parisc-linux.org>
References: <20080515141537.GA22826@beyonder.ift.unesp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515141537.GA22826@beyonder.ift.unesp.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 11:15:37AM -0300, Carlos R. Mafra wrote:
> This observation has already been made by Matthew Wilcox in June 2002
> (http://www.cs.helsinki.fi/linux/linux-kernel/2002-25/0687.html)
> 
> "I notice that none of the current softirq routines use the data element
> passed to them."
> 
> and the situation hasn't changed since them. So it appears we can safely
> remove that extra argument to save 128 (54) bytes of kernel data (text).
> 
> Signed-off-by: Carlos R. Mafra <crmafra@ift.unesp.br>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
