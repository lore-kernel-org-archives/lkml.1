Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbYJXKu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbYJXKu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 06:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbYJXKuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 06:50:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48590 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbYJXKuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 06:50:12 -0400
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: show dma_mask bits in /sys
From: Andi Kleen <andi@firstfloor.org>
References: <1223506943-6543-1-git-send-email-yinghai@kernel.org>
	<20081009211837.GC18444@colo.lackof.org> <48EE7745.2020603@kernel.org>
	<20081009213551.GC25780@parisc-linux.org>
	<86802c440810091451y4a3caceg1abaa75464c40a72@mail.gmail.com>
	<20081009225533.GB1914@colo.lackof.org> <48EE8E55.4000009@kernel.org>
	<20081012071157.GA20056@colo.lackof.org> <48FFD726.2010600@kernel.org>
	<20081023032833.GK26094@parisc-linux.org>
	<20081023064412.GD31186@colo.lackof.org>
Date: Fri, 24 Oct 2008 12:50:12 +0200
In-Reply-To: <20081023064412.GD31186@colo.lackof.org> (Grant Grundler's message of "Thu, 23 Oct 2008 00:44:12 -0600")
Message-ID: <87zlku8dy3.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler <grundler@parisc-linux.org> writes:

> On Wed, Oct 22, 2008 at 09:28:33PM -0600, Matthew Wilcox wrote:
>> On Wed, Oct 22, 2008 at 06:45:10PM -0700, Yinghai Lu wrote:
>> > Grant prefer to add it /sys instead of showing in bootlog
>> > 
>> > so could catch if the driver set the correct dma_mask.
>> 
>> I still don't think this is useful information to be exposing.
>
> It's useful for anyone involved with device drivers - we agree that's
> a very limited subset of users.  I certainly get fed up with trying
> to figure out which dma_mask each driver is using since in some

One simple way that doesn't need any kernel changes is to use
crash on the running kernel. I personally just stuck in printks
when I needed that, but it doesn't strike me as something that 
is generally useful in standard kernels (agreeing with Willy)

-Andi
-- 
ak@linux.intel.com
