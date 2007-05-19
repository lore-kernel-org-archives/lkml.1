Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbXESAG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbXESAG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 20:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbXESAGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 20:06:20 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:13594 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbXESAGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 20:06:19 -0400
Message-ID: <464E3FBD.7090704@oracle.com>
Date: Fri, 18 May 2007 17:07:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linda Walsh <lkml@tlinx.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: building i386 requires s390: "driver/crypto/Kconfig" sourcing
 s390 arch
References: <464DFF5F.5010905@tlinx.org> <20070518141735.aae3921a.randy.dunlap@oracle.com> <464E1E9A.8060605@tlinx.org> <20070518161920.ae0ed062.randy.dunlap@oracle.com> <Pine.LNX.4.64.0705181931180.7794@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0705181931180.7794@localhost.localdomain>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> On Fri, 18 May 2007, Randy Dunlap wrote:
> 
>> On Fri, 18 May 2007 14:46:02 -0700 Linda Walsh wrote:
> 
>>> If the standard that other architectures are using is to put their
>>> devices in the crypto directory, then one might expect all crypto
>>> devices to be there.  Why should s390 stick out and put its crypto
>>> device someplace under the s390 tree, forcing parts of the s390
>>> tree to be included when building other architectures?
>> drivers/crypto/ currently contains drivers for x86_32 and s390 (the
>> latter by indirection, which is what is causing you this
>> grief/problem/whatever), but it certainly looks like it could be a
>> home for crypto drivers on any arch.
> 
> this all sounds vaguely familiar.  oh, wait ...
> 
> http://lkml.org/lkml/2007/3/28/212

I just tried several things to "fix" it, but none of them worked.

I wouldn't mind making missing files in *config be non-fatal, i.e.,
just print a warning message, but I doubt that the maintainer(s)
would accept that.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
