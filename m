Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbZAaKgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbZAaKgT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 05:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbZAaKgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 05:36:09 -0500
Received: from gw.goop.org ([64.81.55.164]:55808 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbZAaKgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 05:36:07 -0500
Message-ID: <49842995.8060705@goop.org>
Date: Sat, 31 Jan 2009 02:36:05 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Gerst <brgerst@gmail.com>, ebiederm@xmission.com,
       cl@linux-foundation.org, rusty@rustcorp.com.au, travis@sgi.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
Subject: Re: [PATCH] percpu: add optimized generic percpu accessors
References: <496C717F.70204@kernel.org> <73c1f2160901130527s2d61f4ewf0725c3bf1b36a1a@mail.gmail.com> <496C9FB7.9050907@kernel.org> <496D8CEB.5060402@zytor.com> <20090114093834.GA19799@elte.hu> <496F0F50.6070200@kernel.org> <20090115113045.GG22850@elte.hu> <496F2032.5080502@kernel.org> <20090115122611.GJ22850@elte.hu> <496F346B.6020804@kernel.org> <20090115130740.GE21839@elte.hu> <496F38C7.5000403@kernel.org>
In-Reply-To: <496F38C7.5000403@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> I also cleaned up the x86-specific APIs and made the x86 code use
> these new generic percpu primitives.
>
> tj: * fixed generic percpu_sub() definition as Roel Kluin pointed out
>     * added percpu_and() for completeness's sake
>     * made generic percpu ops atomic against preemption
>   

Ah, good.  I'm happy.

    J
