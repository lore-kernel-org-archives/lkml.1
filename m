Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbZGAIvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbZGAIvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbZGAIvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:51:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55621 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986AbZGAIvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:51:39 -0400
Message-ID: <4A4B2406.2020901@redhat.com>
Date: Wed, 01 Jul 2009 11:53:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v7 0/5] irqfd fixes and enhancements
References: <20090629181954.1886.20225.stgit@dev.haskins.net>
In-Reply-To: <20090629181954.1886.20225.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2009 09:28 PM, Gregory Haskins wrote:
> (Applies to kvm.git/master:4631e094)
>
> The following is the latest attempt to fix the races in irqfd/eventfd, as
> well as restore DEASSIGN support.  For more details, please read the patch
> headers.  I've restored the slow-work variant of the logic as a separate
> patch (5/5) so we can get a better idea of the true difference between
> the workqueue approach and the slow-work style.  I am personally in favor
> of the slow-work approach since it doesnt require a mostly-idle+dedicated
> thread to hang around.  But that is just me.  5/5 can be ignored, folded
> in to 3/5+4/5 as appropriate, or merged as is per the whim of Avi et. al.
>    

I think a good compromise would be to create the workqueue when the 
first VM is launched.

> As always, this series has been tested against the kvm-eventfd unit test
> with both 5/5 applied and unapplied, and everything appears to be
> functioning properly. You can download this test here:
>
> ftp://ftp.novell.com/dev/ghaskins/kvm-eventfd.tar.bz2
>
> I've included version 4 of Davide's eventfd patch (ported to kvm.git) so
> that its a complete reviewable series.  Note, however, that there may be
> later versions of his patch to consider for merging, so we should
> coordinate with him.
>    

Davide's patch was merged upstream.  Please take a look to make sure 
this patchset is compatible with what was merged.

Patchset looks good to me, but I'd appreciate an ack from Michael (or 
anyone else who's interested).

-- 
error compiling committee.c: too many arguments to function

