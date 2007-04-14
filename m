Return-Path: <linux-kernel-owner+w=401wt.eu-S1030433AbXDNBOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030433AbXDNBOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 21:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbXDNBOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 21:14:54 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:53091 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbXDNBOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 21:14:54 -0400
Message-ID: <46202AEC.9050401@oracle.com>
Date: Fri, 13 Apr 2007 21:14:20 -0400
From: Chuck Lever <chuck.lever@oracle.com>
Reply-To: chuck.lever@oracle.com
Organization: Oracle Corporation
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Mike Snitzer <snitzer@gmail.com>
CC: Roland Dreier <rdreier@cisco.com>, NeilBrown <neilb@suse.de>,
       Andrew Morton <akpm@osdl.org>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: Merge plans for RPC/RDMA? (Was: Re: [NFS] [PATCH 000 of 14] knfsd:
 Preparation for IPv6 support in NFS server.)
References: <170fa0d20704131347u4a28b5d1h1959227980449fbf@mail.gmail.com>	 <46200822.5060800@oracle.com> <170fa0d20704131704y13151149n817cd698e22781c8@mail.gmail.com>
In-Reply-To: <170fa0d20704131704y13151149n817cd698e22781c8@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------080202050009060802050709"
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080202050009060802050709
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Mike Snitzer wrote:
> On 4/13/07, Chuck Lever <chuck.lever@oracle.com> wrote:
>> Mike Snitzer wrote:
>> > On 2/2/07, Chuck Lever <chuck.lever@oracle.com> wrote:
>> >> Roland Dreier wrote:
>> >> >  > They are mostly from Chuck Level and make preparating for IPv6
>> >> support
>> >> >  > in the NFS server.
>> >> >  > They are *not* for 2.6.20, but should be ok for .21.
>> >> >
>> >> > Out of curiousity, does this patch series reduce the delta 
>> between the
>> >> > NFS/RDMA tree and mainline Linux?  In other words does this bring
>> >> > NFS/RDMA closer to merging?
>> >>
>> >> Hi Roland-
>> >>
>> >> The client side support for an RPC/RDMA module is almost completely
>> >> integrated into mainline.  There is still a minimal set of patches
>> >> required to support alternate transports in loadable kernel modules
>> >> which Trond has indicated he will integrate when the RPC/RDMA 
>> transport
>> >> is ready to be integrated.
>> >
>> > Hi Chuck,
>> >
>> > I must be missing something because I don't see _any_ trace of the
>> > core RPC over RDMA support (xprtrdma et al), your RPC Transport
>> > Switch, or any of the other supporting changes in mainline.  Could
>> > you, or others, please clarify the plan for merging RPC/RDMA?
>>
>> The RPC transport switch patches are almost fully integrated into
>> mainline.  The xprtrdma piece is what is not there yet.
> 
> OK, has the xprtrdma piece been reviewed by the community?  What, if
> anything, is preventing the code from being included in -mm for wider
> testing?

OK, there is something holding up the client-side piece of NFS/RDMA. 
There is some hackery required for the NFS client to recognize that the 
RDMA transport should be used instead of the standard socket transport.

We did discuss this a bit at Connectathon '07 six weeks ago, but my 
impression is that more discussion is required.

I'm working on some changes to NFS mounting that would move NFS mount 
option parsing into the kernel.  This would make it very simple to add 
RDMA transport support, but it's rather a while in coming.

--------------080202050009060802050709
Content-Type: text/x-vcard; charset=utf-8;
 name="chuck.lever.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="chuck.lever.vcf"

begin:vcard
fn:Chuck Lever
n:Lever;Chuck
org:Oracle Corporation;Corporate Architecture: Linux Projects Group
adr:;;1015 Granger Avenue;Ann Arbor;MI;48104;USA
email;internet:chuck dot lever at nospam oracle dot com
title:Principal Member of Staff
tel;work:+1 248 614 5091
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------080202050009060802050709--
