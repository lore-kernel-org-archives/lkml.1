Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786AbZGXNQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbZGXNQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 09:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbZGXNQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 09:16:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42889 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbZGXNQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 09:16:53 -0400
Date: Fri, 24 Jul 2009 15:16:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] x86: Use clflush() instead of wbinvd() whenever
	possible when changing mapping
Message-ID: <20090724131649.GC2045@basil.fritz.box>
References: <1248421981-31865-1-git-send-email-thellstrom@vmware.com> <87ocra1jn6.fsf@basil.nowhere.org> <4A698B3E.4020208@vmware.com> <20090724105831.GB2045@basil.fritz.box> <4A699784.9020803@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A699784.9020803@vmware.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No. It was motivated by the assumption that wbinvd() is just bad:

Ok, got it now.

> Qoute:
>
> WBINVD is a very nasty operation. I was talking to some CPU people and they 
> really recommended to get rid of it as far as possible. Stopping the CPU 
> for msecs is just wrong and there are apparently even some theoretical live 
> lock situations. - It is not interruptible in earlier VT versions and 
> messes up real time in the hypervisor. Some people were doing KVM on rt 
> kernels and had latency spikes from that.
>
>
> /Qoute
> (I believe you wrote that ?)

Yes. That's still true and that's one reason to not use it.

-Andi
