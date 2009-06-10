Return-Path: <linux-kernel-owner+w=401wt.eu-S1760808AbZFJRoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808AbZFJRoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 13:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756528AbZFJRny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 13:43:54 -0400
Received: from smtp-out.google.com ([216.239.45.13]:33486 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024AbZFJRny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 13:43:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ehE2sj5TiD0UZHLVlomk5QOteEW7ybpdpXwuFkhI7508SgxcTBIis7t6XEk8fuRpP
	EByOU4VIYlXpsu/yuZUqw==
MIME-Version: 1.0
In-Reply-To: <20090610103131.GB13885@elf.ucw.cz>
References: <20090610103131.GB13885@elf.ucw.cz>
Date: Wed, 10 Jun 2009 10:43:53 -0700
Message-ID: <a55d774e0906101043q580fc5e5iad25a79203dc52c@mail.gmail.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       ibm@android.com, san@android.com, rlove@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 3:31 AM, Pavel Machek<pavel@ucw.cz> wrote:
> Hi!
>
> Is there patch for Dream support for 2.6.30 somewhere? The best I
> could find is linux-msm tree, which is ... quite a big diff against
> 2.6.24:

Our current working tree (for the donut branch) is against 2.6.29:
http://android.git.kernel.org/?p=kernel/msm.git;a=shortlog;h=refs/heads/android-msm-2.6.29

The cupcake/1.5 system update (latest production kernel) was against 2.6.27:
http://android.git.kernel.org/?p=kernel/msm.git;a=shortlog;h=refs/heads/android-msm-2.6.27

> Is all of it neccessary for dream or are parts such as board-halibut
> parts of some other support? Do I have wrong tree entirely?

Most of it is necessary.  board-halibut is a qualcomm reference
design.  board-sapphire is HTC Magic.  board-trout is G1/ADP1.
arch/arm/config/msm_defconfig is how we configure the kernel we ship
which supports all three.

The ti wifi driver is enormous and in its own repository:
http://android.git.kernel.org/?p=platform/system/wlan/ti.git;a=shortlog;h=refs/heads/cupcake

Brian
