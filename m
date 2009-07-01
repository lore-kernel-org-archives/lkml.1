Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbZGAJEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbZGAJEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754448AbZGAJEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:04:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50391 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbZGAJEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:04:23 -0400
Date: Wed, 1 Jul 2009 12:03:54 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v7 0/5] irqfd fixes and enhancements
Message-ID: <20090701090354.GA14046@redhat.com>
References: <20090629181954.1886.20225.stgit@dev.haskins.net> <4A4B2406.2020901@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4B2406.2020901@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 11:53:26AM +0300, Avi Kivity wrote:
> On 06/29/2009 09:28 PM, Gregory Haskins wrote:
>> (Applies to kvm.git/master:4631e094)
>>
>> The following is the latest attempt to fix the races in irqfd/eventfd, as
>> well as restore DEASSIGN support.  For more details, please read the patch
>> headers.  I've restored the slow-work variant of the logic as a separate
>> patch (5/5) so we can get a better idea of the true difference between
>> the workqueue approach and the slow-work style.  I am personally in favor
>> of the slow-work approach since it doesnt require a mostly-idle+dedicated
>> thread to hang around.  But that is just me.  5/5 can be ignored, folded
>> in to 3/5+4/5 as appropriate, or merged as is per the whim of Avi et. al.
>>    
>
> I think a good compromise would be to create the workqueue when the  
> first VM is launched.
>
>> As always, this series has been tested against the kvm-eventfd unit test
>> with both 5/5 applied and unapplied, and everything appears to be
>> functioning properly. You can download this test here:
>>
>> ftp://ftp.novell.com/dev/ghaskins/kvm-eventfd.tar.bz2
>>
>> I've included version 4 of Davide's eventfd patch (ported to kvm.git) so
>> that its a complete reviewable series.  Note, however, that there may be
>> later versions of his patch to consider for merging, so we should
>> coordinate with him.
>>    
>
> Davide's patch was merged upstream.  Please take a look to make sure  
> this patchset is compatible with what was merged.
>
> Patchset looks good to me, but I'd appreciate an ack from Michael (or  
> anyone else who's interested).

For patches 1,3,4:
Acked-by: Michael S. Tsirkin <mst@redhat.com>

As for 5: IMHO, let's keep it simple meanwhile.


-- 
MST
