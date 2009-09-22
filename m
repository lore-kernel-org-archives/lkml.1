Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbZIVKVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbZIVKVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 06:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755901AbZIVKVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 06:21:14 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48714 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860AbZIVKVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 06:21:13 -0400
Subject: Re: [RFC PATCH 0/3] Fix SLQB on memoryless configurations V2
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <20090922100540.GD12254@csn.ul.ie>
References: <1253549426-917-1-git-send-email-mel@csn.ul.ie>
	 <20090921174656.GS12726@csn.ul.ie>
	 <alpine.DEB.1.10.0909211349530.3106@V090114053VZO-1>
	 <20090921180739.GT12726@csn.ul.ie>
	 <alpine.DEB.1.10.0909211412050.3106@V090114053VZO-1>
	 <20090922100540.GD12254@csn.ul.ie>
Date: Tue, 22 Sep 2009 13:21:15 +0300
Message-Id: <1253614875.30406.12.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Tue, 2009-09-22 at 11:05 +0100, Mel Gorman wrote:
> I'm going to punt the decision on this one to Pekka or Nick. My feeling
> is leave it enabled for NUMA so it can be identified if it gets fixed
> for some other reason - e.g. the stalls are due to a per-cpu problem as
> stated by Sachin and SLQB happens to exasperate the problem.

Can I have a tested patch that uses MAX_NUMNODES to allocate the
structs, please? We can convert SLQB over to per-cpu allocator if the
memoryless node issue is resolved.

			Pekka

