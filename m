Return-Path: <linux-kernel-owner+w=401wt.eu-S934746AbZAPNt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934746AbZAPNt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 08:49:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762764AbZAPNtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 08:49:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:51498 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760840AbZAPNtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 08:49:46 -0500
Message-ID: <49709062.7070600@kernel.org>
Date: Fri, 16 Jan 2009 22:49:22 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Christoph Lameter <cl@linux-foundation.org>,
       roel kluin <roel.kluin@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Gerst <brgerst@gmail.com>, ebiederm@xmission.com,
       rusty@rustcorp.com.au, travis@sgi.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, steiner@sgi.com, hugh@veritas.com
Subject: Re: [patch] add optimized generic percpu accessors
References: <496C9FB7.9050907@kernel.org> <496D8CEB.5060402@zytor.com> <20090114093834.GA19799@elte.hu> <25e057c00901150204x61c54d9fl91afe23477d1f12f@mail.gmail.com> <496F0F5E.3080404@kernel.org> <20090115113230.GH22850@elte.hu> <496F1FA6.6050204@kernel.org> <20090115122222.GI22850@elte.hu> <Pine.LNX.4.64.0901151430470.28153@quilx.com> <4970564F.8030004@kernel.org> <20090116132344.GB20593@elte.hu>
In-Reply-To: <20090116132344.GB20593@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 16 Jan 2009 13:49:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Ingo Molnar wrote:
>>> Most of that is based on earlier patches by me.
>> Sorry, I didn't know that.  Ingo, please feel free to re-base the tree 
>> with updated credits.
> 
> Sure, i've rebased it and added this to the front of every affected patch:
> 
> [ Based on original patch from Christoph Lameter and Mike Travis. ]

Good.

> I've also first pulled your latest tree, please base new changes and new 
> pull requests on the tip/x86/percpu tree i just pushed out.
> 
> I also merged tip/x86/percpu into tip/master and resumed testing it.

Great.

> I suspect the next step will be to integrate Brian's "get rid of the rest 
> of the PDA" patches?

Yeap, Brian, any progress?  If you don't have the time, feel free to
just shoot the patches my way.

Thanks.

-- 
tejun
