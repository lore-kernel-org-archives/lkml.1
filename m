Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbYKDWyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbYKDWyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbYKDWy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:54:27 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:58002 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbYKDWy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:54:26 -0500
Date: Tue, 4 Nov 2008 16:52:48 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: peterz@infradead.org, rientjes@google.com, npiggin@suse.de,
       menage@google.com, dfults@sgi.com, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [patch 0/7] cpuset writeback throttling
In-Reply-To: <20081104143534.b5c16147.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0811041648350.6254@quilx.com>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
 <20081104124753.fb1dde5a.akpm@linux-foundation.org> <1225831988.7803.1939.camel@twins>
 <20081104131637.68fbe055.akpm@linux-foundation.org> <1225833710.7803.1993.camel@twins>
 <20081104135004.f1717fcf.akpm@linux-foundation.org> <Pine.LNX.4.64.0811041601100.5077@quilx.com>
 <20081104143534.b5c16147.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008, Andrew Morton wrote:

> To fix this with a memcg-based throttling, the operator would need to
> be able to create memcg's which have pages only from particular nodes.
> (That's a bit indirect relative to what they want to do, but is
> presumably workable).

The system would need to have the capability to find the memcg groups that 
have dirty pages for a certain inode. Files are not constrained to nodes 
or memcg groups.

