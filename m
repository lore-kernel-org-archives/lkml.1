Return-Path: <linux-kernel-owner+w=401wt.eu-S1760294AbYCYT2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760294AbYCYT2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 15:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760052AbYCYT1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 15:27:16 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41590 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758141AbYCYT04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 15:26:56 -0400
Date: Tue, 25 Mar 2008 12:25:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Luck, Tony" <tony.luck@intel.com>
cc: David Miller <davem@davemloft.net>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Subject: RE: [11/14] vcompound: Fallbacks for order 1 stack allocations on
 IA64 and x86
In-Reply-To: <1FE6DD409037234FAB833C420AA843ECE9DDFA@orsmsx424.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.64.0803251223470.17521@schroedinger.engr.sgi.com>
References: <20080321061726.782068299@sgi.com> <20080321.002502.223136918.davem@davemloft.net>
 <Pine.LNX.4.64.0803211037140.18671@schroedinger.engr.sgi.com>
 <20080321.145712.198736315.davem@davemloft.net>
 <Pine.LNX.4.64.0803241121090.3002@schroedinger.engr.sgi.com>
 <1FE6DD409037234FAB833C420AA843ECE5B84D@orsmsx424.amr.corp.intel.com>
 <Pine.LNX.4.64.0803251036410.15870@schroedinger.engr.sgi.com>
 <1FE6DD409037234FAB833C420AA843ECE9DDFA@orsmsx424.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008, Luck, Tony wrote:

> dtr[1] : maps an area of region 7 that spans kernel stack
>          page size is kernel granule size (default 16M).
>          This mapping needs to be reset on a context switch
>          where we move to a stack in a different granule.

Interesting.... Never realized we were doing these tricks with DTR.

