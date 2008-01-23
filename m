Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbYAWORl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbYAWORl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 09:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYAWORd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 09:17:33 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:36667
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbYAWORc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 09:17:32 -0500
Message-ID: <47974C78.7050509@qumranet.com>
Date: Wed, 23 Jan 2008 16:17:28 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: Gerd Hoffmann <kraxel@redhat.com>, Christoph Lameter <clameter@sgi.com>,
       Andrea Arcangeli <andrea@qumranet.com>, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [kvm-devel] [PATCH] export notifier #1
References: <478E4356.7030303@qumranet.com> <20080117162302.GI7170@v2.random> <478F9C9C.7070500@qumranet.com> <20080117193252.GC24131@v2.random> <20080121125204.GJ6970@v2.random> <4795F9D2.1050503@qumranet.com> <20080122144332.GE7331@v2.random> <20080122200858.GB15848@v2.random> <Pine.LNX.4.64.0801221232040.28197@schroedinger.engr.sgi.com> <4797384B.7080200@redhat.com> <20080123131939.GJ26420@sgi.com>
In-Reply-To: <20080123131939.GJ26420@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt wrote:
> On Wed, Jan 23, 2008 at 01:51:23PM +0100, Gerd Hoffmann wrote:
>   
>> Jumping in here, looks like this could develop into a direction useful
>> for Xen.
>>
>> Background:  Xen has a mechanism called "grant tables" for page sharing.
>>  Guest #1 can issue a "grant" for another guest #2, which in turn then
>> can use that grant to map the page owned by guest #1 into its address
>> space.  This is used by the virtual network/disk drivers, i.e. typically
>> Domain-0 (which has access to the real hardware) maps pages of other
>> guests to fill in disk/network data.
>>     
>
> This is extremely similar to what XPMEM is providing.
>
>   

I think that in Xen's case the page tables are the normal cpu page 
tables, not an external mmu (like RDMA, kvm, and XPMEM).

-- 
error compiling committee.c: too many arguments to function

