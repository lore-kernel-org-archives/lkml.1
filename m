Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbZCEXXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbZCEXXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757138AbZCEXXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:23:20 -0500
Received: from sous-sol.org ([216.99.217.87]:49572 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757135AbZCEXXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:23:19 -0500
Date: Thu, 5 Mar 2009 15:22:19 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       iommu@lists.linux-foundation.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][GIT PULL] dma-api debugging facility
Message-ID: <20090305232219.GG24280@sequoia.sous-sol.org>
References: <20090305200338.GA31182@amd.com> <20090306055944Q.fujita.tomonori@lab.ntt.co.jp> <20090305223302.GN2125@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305223302.GN2125@8bytes.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joerg Roedel (joro@8bytes.org) wrote:
> Thats fixed in the tree above. I will send out the patches tomorrow
> seperatly for easier reviewing and commenting.

Did you fix the incorrect usage of __cacheline_aligned_in_smp?

essentially:

-} __cacheline_aligned_in_smp;
+} ____cacheline_aligned_in_smp;
