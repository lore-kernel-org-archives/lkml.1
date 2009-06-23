Return-Path: <linux-kernel-owner+w=401wt.eu-S1757114AbZFWLwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbZFWLwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbZFWLwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:52:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44088 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbZFWLwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:52:08 -0400
Message-ID: <4A40C21C.2000504@redhat.com>
Date: Tue, 23 Jun 2009 14:53:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH RFC] pass write value to in_range pointers
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090622151631.GA14780@redhat.com> <4A3FA6FC.9030301@novell.com> <20090622160833.GA15228@redhat.com> <4A3FB156.3030301@novell.com> <20090622172720.GC15228@redhat.com> <4A405436.1080100@gmail.com>
In-Reply-To: <4A405436.1080100@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2009 07:04 AM, Gregory Haskins wrote:
> Well, for one its not very clear what the benefit of the read/write
> aliasing even is. ;)  Apparently coalesced_mmio uses it, but even so I
> doubt that is for the purposes of having one device do reads while
> another does writes.  I could be wrong, though.
>    

Coalesced mmio cannot handle reads.

-- 
error compiling committee.c: too many arguments to function

