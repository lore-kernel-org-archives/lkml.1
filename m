Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbZCQPvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbZCQPvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 11:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982AbZCQPvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 11:51:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60336 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbZCQPvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 11:51:46 -0400
Message-ID: <49BFC6CB.9070603@zytor.com>
Date: Tue, 17 Mar 2009 08:50:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, akataria@vmware.com
Subject: Re: [PATCH -tip] x86: move vmware to hypervisor
References: <1237281581.7907.2.camel@ht.satnam>	 <20090317093919.GD6477@elte.hu> <1237283318.7907.9.camel@ht.satnam>
In-Reply-To: <1237283318.7907.9.camel@ht.satnam>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
>> I dont really like this one. KVM is a hypervisor too, and so is 
>> Xen and lguest. VMware is one of the many types of a 
>> hypervisors.
> 
> Can we use common hypervisor for Xen, lguest, vmware, etc.
> And Xen, lguest, vmware will be the sub-options.

Obviously.  We spent a lot of time breaking up the cpu stuff into common
and vendor-specific portions, we shouldn't go backwards w.r.t. hypervisors.
	
	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

