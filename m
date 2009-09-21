Return-Path: <linux-kernel-owner+w=401wt.eu-S1752679AbZIUSCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbZIUSCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 14:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbZIUSCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 14:02:36 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:46073 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752318AbZIUSCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 14:02:32 -0400
Date: Mon, 21 Sep 2009 13:54:12 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Mel Gorman <mel@csn.ul.ie>
cc: Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH 0/3] Fix SLQB on memoryless configurations V2
In-Reply-To: <20090921174656.GS12726@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0909211349530.3106@V090114053VZO-1>
References: <1253549426-917-1-git-send-email-mel@csn.ul.ie> <20090921174656.GS12726@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lets just keep SLQB back until the basic issues with memoryless nodes are
resolved. There does not seem to be an easy way to deal with this. Some
thought needs to go into how memoryless node handling relates to per cpu
lists and locking. List handling issues need to be addressed before SLQB.
can work reliably. The same issues can surface on x86 platforms with weird
NUMA memory setups.

Or just allow SLQB for !NUMA configurations and merge it now.
