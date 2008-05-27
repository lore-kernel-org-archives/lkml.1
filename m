Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbYE0SFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbYE0SFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 14:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755831AbYE0SEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 14:04:51 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48402 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756732AbYE0SEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 14:04:51 -0400
Date: Tue, 27 May 2008 11:04:48 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Eric Sesterhenn <snakebyte@gmx.de>, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, James Morris <jmorris@namei.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: Redzone overwritten with CONFIG_SECURITY
In-Reply-To: <84144f020805271059k11498424w3435b748f5254e2e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0805271104100.18436@schroedinger.engr.sgi.com>
References: <20080526143422.GA3203@alice>  <84144f020805270800l5911ed02ia7a92d96a8aa32a7@mail.gmail.com>
  <20080527151136.GA20750@alice> <20080527161148.GA7291@alice>
 <84144f020805271059k11498424w3435b748f5254e2e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008, Pekka Enberg wrote:

> Then it's likely that we corrupt hugetlbfs_inode_cachep because of
> SLUB merging and the real problem is somewhere else. Can you also try
> passing 'slub_nomerge" as a kernel parameter with SLUB?

Enabling Redzone disables merging. So its unrelated to merging.
 
