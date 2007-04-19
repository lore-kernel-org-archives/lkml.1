Return-Path: <linux-kernel-owner+w=401wt.eu-S1766982AbXDSU4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766982AbXDSU4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 16:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766985AbXDSU4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 16:56:09 -0400
Received: from terminus.zytor.com ([192.83.249.54]:59023 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766982AbXDSU4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 16:56:08 -0400
Message-ID: <4627D756.5020405@zytor.com>
Date: Thu, 19 Apr 2007 13:55:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Chuck Ebbert <cebbert@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem
 mappings
References: <20070414204154.871250608@goop.org> <20070414204924.125386443@goop.org> <4627D57C.4070809@redhat.com> <200704192250.52633.ak@suse.de>
In-Reply-To: <200704192250.52633.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Is some version of this going in for 2.6.21, or is it not a real problem?
> 
> When it's only seen with Xen it's not a real problem right now.

It's not just seen only with Xen, though.  It will affect all kernels in 
a particular range of sizes, and we have ordinary kernels covering that 
range (in fact, Xen hardly affects size in that way.)

	-hpa
