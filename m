Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbZHFHPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbZHFHPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 03:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbZHFHPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 03:15:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36912 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbZHFHPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 03:15:30 -0400
Date: Thu, 6 Aug 2009 09:15:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 1/7] x86: add CONFIG_KEXEC_AUTO_RESERVE
Message-ID: <20090806071526.GA22124@basil.fritz.box>
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain> <20090805112133.6552.69619.sendpatchset@localhost.localdomain> <87zlaeiakr.fsf@basil.nowhere.org> <4A7A3807.8090803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7A3807.8090803@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> More useful would seem a crashkernel=size@auto
>>   
> We already have this, just use "crashkernel=size@0". :)

When it's already there then I don't see the point of the feature at all.

Hardcoding the size doesn't really make any sense to me, especially
a suspicious one like 128MB.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
