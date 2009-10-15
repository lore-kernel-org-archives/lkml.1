Return-Path: <linux-kernel-owner+w=401wt.eu-S1757515AbZJOH1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbZJOH1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 03:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757289AbZJOH1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 03:27:32 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:33828 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953AbZJOH1b convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;6:2>);
	Thu, 15 Oct 2009 03:27:31 -0400
Message-Id: <4AD6EB17020000780001A050@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 15 Oct 2009 08:27:51 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Hollis Blanchard" <hollisb@us.ibm.com>
Cc: <sfr@canb.auug.org.au>, <akpm@linux-foundation.org>,
       <linuxppc-dev@lists.ozlabs.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>, <kvm-ppc@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>
Subject: Re: linux-next: tree build failure
References: <4AC1E15502000078000516B5@vpn.id2.novell.com>
 <1254267572.15622.1621.camel@slab.beaverton.ibm.com>
 <4AC318450200007800017355@vpn.id2.novell.com>
 <1254498517.3839.17.camel@slab.beaverton.ibm.com>
 <4AC9B5310200007800017EA1@vpn.id2.novell.com>
 <1255115648.2546.71.camel@slab.beaverton.ibm.com>
 <1255561026.29192.0.camel@slab.beaverton.ibm.com>
In-Reply-To: <1255561026.29192.0.camel@slab.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Hollis Blanchard <hollisb@us.ibm.com> 15.10.09 00:57 >>>
>On Fri, 2009-10-09 at 12:14 -0700, Hollis Blanchard wrote:
>> Rusty's version of BUILD_BUG_ON() does indeed fix the build break, and
>> also exposes the bug in kvmppc_account_exit_stat(). So to recap:
>> 
>> original: built but didn't work
>> Jan's: doesn't build
>> Rusty's: builds and works
>> 
>> Where do you want to go from here?
>
>Jan, what are your thoughts? Your BUILD_BUG_ON patch has broken the
>build, and we still need to fix it.

My perspective is that it just uncovered already existing brokenness. And
honestly, I won't be able to get to look into this within the next days. (And
btw., when I run into issues with other people's code changes, quite
frequently I'm told to propose a patch, so I'm also having some
philosophical problem understanding why I can't simply expect the same
when people run into issues with changes I made, especially in cases like
this where it wasn't me introducing the broken code.) So, if this can wait
for a couple of days, I can try to find time to look into this. Otherwise, I'd
rely on someone running into the actual issue to implement a solution.

Jan

