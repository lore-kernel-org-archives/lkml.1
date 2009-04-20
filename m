Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbZDTKBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbZDTKBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 06:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbZDTKBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 06:01:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56458 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbZDTKBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 06:01:01 -0400
Date: Mon, 20 Apr 2009 12:04:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
       Huang Ying <ying.huang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Add MCE support to KVM
Message-ID: <20090420100421.GX14687@one.firstfloor.org>
References: <1239332455.6384.108.camel@yhuang-dev.sh.intel.com> <49E08762.1010206@redhat.com> <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com> <49E337D7.5050502@redhat.com> <49EA515C.9000507@codemonkey.ws> <49EAE1F6.9050205@redhat.com> <49EC29D1.8040407@redhat.com> <49EC3198.9070902@redhat.com> <49EC3987.2040001@redhat.com> <49EC3AD6.3090905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EC3AD6.3090905@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It depends if the MSR may be considered global, or is required to be 
> per-cpu.  Need to refresh my memory on this, but I remember reading this 

Machine Check MSRs need to be per CPU. The latest kernels have some support
for "shared banks" (between CPUs) but it's better to not have it and
older OS don't like it.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
