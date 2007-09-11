Return-Path: <linux-kernel-owner+w=401wt.eu-S1760958AbXIKE6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760958AbXIKE6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 00:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbXIKE6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 00:58:09 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46037 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbXIKE6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 00:58:08 -0400
Message-ID: <46E61FEA.9010800@in.ibm.com>
Date: Tue, 11 Sep 2007 10:26:10 +0530
From: suzuki <suzuki@in.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, bfields@fieldses.org,
       neilb@suse.de, nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       ffilz@us.ibm.com, Poornima <bnpoorni@in.ibm.com>
Subject: Re: [NFS] [BUG] 2.6.23-rc5 kernel BUG at fs/nfs/nfs4xdr.c:945
References: <46E121B8.4080105@linux.vnet.ibm.com> <6bffcb0e0709071656o6881fa17y61818a9733293a4c@mail.gmail.com> <1189289549.13713.4.camel@localhost.localdomain> <46E4FC2F.6040105@in.ibm.com> <1189458228.6634.4.camel@heimdal.trondhjem.org>
In-Reply-To: <1189458228.6634.4.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote:
> On Mon, 2007-09-10 at 13:41 +0530, suzuki wrote:
>> Hi
>>
>> I have been trying to debug this issue from my side and could find the 
>> following.
>>
>> The pathconf() request gets a reply with :
>>
>> pathinfo.max_namelen = (unsiged int) -1
>> pathinfo.max_link    = 255
>>
>> Is this really an expected answer from a server for a proper connection 
>> ( for mount requests on an exported dir) ? Is there something that needs 
>> to be fixed at server side ?
> 
> I assume that this is with my patch applied? 

No. This is without your patch. So I am trying to debug why the server 
is sending a -1 ! (which sounds like an error ?)

Thanks

Suzuki K P
IBM Linux Technology Centre

Yes: as long as the kernel
> sets NAME_MAX to 255, then the above is expected behaviour.
> 
> Trond
> 

