Return-Path: <linux-kernel-owner+w=401wt.eu-S1764755AbYCEJ4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764755AbYCEJ4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 04:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758550AbYCEJ4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 04:56:35 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:34162
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757992AbYCEJ4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 04:56:34 -0500
Message-ID: <47CE6D8D.9060306@qumranet.com>
Date: Wed, 05 Mar 2008 11:53:17 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Andrea Arcangeli <andrea@qumranet.com>, Jack Steiner <steiner@sgi.com>,
       Nick Piggin <npiggin@suse.de>, akpm@linux-foundation.org,
       kvm-devel@lists.sourceforge.net, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [RFC] Notifier for Externally Mapped Memory (EMM)
References: <20080303213707.GA8091@v2.random> <20080303220502.GA5301@v2.random> <47CC9B57.5050402@qumranet.com> <Pine.LNX.4.64.0803032327470.9642@schroedinger.engr.sgi.com> <20080304133020.GC5301@v2.random> <Pine.LNX.4.64.0803041059110.13957@schroedinger.engr.sgi.com> <20080304222030.GB8951@v2.random> <Pine.LNX.4.64.0803041422070.20821@schroedinger.engr.sgi.com> <1204670529.6241.52.camel@lappy> <47CE2B23.6010505@qumranet.com> <20080305094736.GA2013@sgi.com>
In-Reply-To: <20080305094736.GA2013@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (firebolt.argo.co.il [0.0.0.0]); Wed, 05 Mar 2008 11:53:17 +0200 (IST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt wrote:
> On Wed, Mar 05, 2008 at 07:09:55AM +0200, Avi Kivity wrote:
>   
>> Isn't that out of the question for .25?
>>     
>
> I keep hearing this mantra.  What is so compelling about the .25
> release?  When seems to be more important than what.  While I understand
> product release cycles, etc. and can certainly agree with them. I would
> like to know with what I am being asked to agree.
>
>   

kvm gained the ability to swap in 2.6.25.  Without mmu notifiers, 
though, the guest can still easily pin all of its memory.

> That said, I agree we should probably finish getting the comments on
> Andrea's most recent patch, if any, cleared up and put that one in.
>   

Great.  Thanks.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

