Return-Path: <linux-kernel-owner+w=401wt.eu-S965694AbXDWJrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965694AbXDWJrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 05:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965695AbXDWJrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 05:47:55 -0400
Received: from ns2.suse.de ([195.135.220.15]:48140 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965694AbXDWJrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 05:47:55 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Joachim Deguara" <joachim.deguara@amd.com>
Subject: Re: [PATCH] x86_64: make GART PTEs uncacheable
Date: Mon, 23 Apr 2007 11:47:50 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, "Langsdorf, Mark" <mark.langsdorf@amd.com>
References: <200704231114.10327.joachim.deguara@amd.com> <200704231132.30736.ak@suse.de> <200704231145.11806.joachim.deguara@amd.com>
In-Reply-To: <200704231145.11806.joachim.deguara@amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704231147.50272.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2007 11:45:11 Joachim Deguara wrote:

> I can work on that as a side note, but while the GART IOMMU is still in the 
> kernel then we need this fix.

If it's too slow we can just use swiotlb instead. Probably while enlarging it.

-Andi
