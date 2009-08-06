Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbZHFM3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbZHFM3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 08:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbZHFM3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 08:29:42 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:23542 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbZHFM3l convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ghaskins@novell.com;3:2>);
	Thu, 6 Aug 2009 08:29:41 -0400
Message-Id: <4A7A8FBD0200005A00051B8A@sinclair.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 Beta 
Date: Thu, 06 Aug 2009 06:09:33 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: <alacrityvm-devel@lists.sourceforge.net>, <kvm@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/7] AlacrityVM guest drivers Reply-To:
References: <20090803171030.17268.26962.stgit@dev.haskins.net>
 <20090806081955.GA9752@redhat.com> <20090806101702.GA10605@redhat.com>
In-Reply-To: <20090806101702.GA10605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 8/6/2009 at  6:17 AM, in message <20090806101702.GA10605@redhat.com>,
"Michael S. Tsirkin" <mst@redhat.com> wrote: 
> On Thu, Aug 06, 2009 at 11:19:56AM +0300, Michael S. Tsirkin wrote:
>> On Mon, Aug 03, 2009 at 01:17:30PM -0400, Gregory Haskins wrote:
>> > (Applies to v2.6.31-rc5, proposed for linux-next after review is complete)
>> 
>> These are guest drivers, right? Merging the guest first means relying on
>> kernel interface from an out of tree driver, which well might change
>> before it goes in.  Would it make more sense to start merging with the
>> host side of the project?
>> 
>> > This series implements the guest-side drivers for accelerated IO
>> > when running on top of the AlacrityVM hypervisor, the details of
>> > which you can find here:
>> > 
>> > http://developer.novell.com/wiki/index.php/AlacrityVM
>> 
>> Since AlacrityVM is kvm based, Cc kvm@vger.kernel.org.
>> 
>> > This series includes the basic plumbing, as well as the driver for
>> > accelerated 802.x (ethernet) networking.
>> 
>> The graphs comparing virtio with vbus look interesting.
>> However, they do not compare apples to apples, do they?
>> These compare userspace virtio with kernel vbus, where for
>> apples to apples comparison one would need to compare
>> kernel virtio with kernel vbus. Right?
> 
> Or userspace virtio with userspace vbus.

Note: That would be pointless.

-Greg


