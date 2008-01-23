Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbYAWOgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbYAWOgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 09:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbYAWOgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 09:36:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbYAWOgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 09:36:45 -0500
Message-ID: <479750CA.4070101@redhat.com>
Date: Wed, 23 Jan 2008 15:35:54 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: Christoph Lameter <clameter@sgi.com>,
       Andrea Arcangeli <andrea@qumranet.com>, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>,
       kvm-devel@lists.sourceforge.net, daniel.blueman@quadrics.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [kvm-devel] [PATCH] export notifier #1
References: <478F9C9C.7070500@qumranet.com> <20080117193252.GC24131@v2.random> <20080121125204.GJ6970@v2.random> <4795F9D2.1050503@qumranet.com> <20080122144332.GE7331@v2.random> <20080122200858.GB15848@v2.random> <Pine.LNX.4.64.0801221232040.28197@schroedinger.engr.sgi.com> <4797384B.7080200@redhat.com> <20080123131939.GJ26420@sgi.com> <47974B54.30407@redhat.com> <20080123141814.GE3058@sgi.com>
In-Reply-To: <20080123141814.GE3058@sgi.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt wrote:
> We have a seg structure which is similar to some structure you probably
> have which describes the grant.  One of the things hanging off that
> seg structure is essentially a page table containing PFNs with their
> respective flags (XPMEM specific and not the same as the pfn flags in
> the processor page tables).

i.e. page tables used by hardware != cpu, right?

In the Xen guest case the normal processor page tables are modified, but
in a special way to make the Xen hypervisor also release the grant.

cheers,
  Gerd
