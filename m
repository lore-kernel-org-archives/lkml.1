Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbZGIV2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbZGIV2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 17:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbZGIV2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 17:28:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55711 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177AbZGIV2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 17:28:13 -0400
Message-ID: <4A5660CB.5080607@redhat.com>
Date: Thu, 09 Jul 2009 17:27:39 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, linux-kernel@vger.kernel.org,
       npiggin@suse.de, akpm@osdl.org, jeremy@goop.org,
       xen-devel@lists.xensource.com, tmem-devel@oss.oracle.com,
       alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org, kurt.hackel@oracle.com,
       Rusty Russell <rusty@rustcorp.com.au>, dave.mccracken@oracle.com,
       Marcelo Tosatti <mtosatti@redhat.com>, sunil.mushran@oracle.com,
       Avi Kivity <avi@redhat.com>, Schwidefsky <schwidefsky@de.ibm.com>,
       chris.mason@oracle.com, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 0/4] (Take 2): transcendent memory ("tmem") for Linux
References: <c0e57d57-3f36-4405-b3f1-1a8c48089394@default>
In-Reply-To: <c0e57d57-3f36-4405-b3f1-1a8c48089394@default>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Magenheimer wrote:

> I'm not saying either one is bad or good -- and I'm sure
> each can be adapted to approximately deliver the value
> of the other -- they are just approaching the same problem
> from different perspectives.

Indeed.  Tmem and auto-ballooning have a simple mechanism,
but the policy required to make it work right could well
be too complex to ever get right.

CMM2 has a more complex mechanism, but the policy is
absolutely trivial.

CMM2 and auto-ballooning seem to give about similar
performance gains on zSystem.

I suspect that for Xen and KVM, we'll want to choose
for the approach that has the simpler policy, because
relying on different versions of different operating
systems to all get the policy of auto-ballooning or
tmem right is likely to result in bad interactions
between guests and other intractable issues.

-- 
All rights reversed.
