Return-Path: <linux-kernel-owner+w=401wt.eu-S1753587AbYAWMe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbYAWMe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 07:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbYAWMet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 07:34:49 -0500
Received: from relay1.sgi.com ([192.48.171.29]:57946 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751761AbYAWMes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 07:34:48 -0500
Date: Wed, 23 Jan 2008 06:34:47 -0600
From: Robin Holt <holt@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Christoph Lameter <clameter@sgi.com>, Izik Eidus <izike@qumranet.com>,
       Andrew Morton <akpm@osdl.org>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [kvm-devel] [PATCH] export notifier #1
Message-ID: <20080123123447.GI26420@sgi.com>
References: <20080121125204.GJ6970@v2.random> <4795F9D2.1050503@qumranet.com> <20080122144332.GE7331@v2.random> <20080122200858.GB15848@v2.random> <Pine.LNX.4.64.0801221232040.28197@schroedinger.engr.sgi.com> <20080122223139.GD15848@v2.random> <Pine.LNX.4.64.0801221433080.2271@schroedinger.engr.sgi.com> <479716AD.5070708@qumranet.com> <20080123105246.GG26420@sgi.com> <20080123120446.GF15848@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080123120446.GF15848@v2.random>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why don't you stick to mm+va and use get_user_pages and let the VM do
> the swapins etc...?

Our concern is also with memory protections for the physical page.
Additionally, we need to support exporting of memory in a VM_PFNMAP
address ranges (specifically, memory mapped using sgi_fetchop, uncached
or cached mspec devices).

Thanks,
Robin
