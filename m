Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbYHSGzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbYHSGzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 02:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbYHSGzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 02:55:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbYHSGzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 02:55:02 -0400
Message-ID: <48AA6DC4.9060709@redhat.com>
Date: Tue, 19 Aug 2008 08:52:52 +0200
From: Chris Lalancette <clalance@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: [PATCH]: Expand Xen blkfront for > 16 xvd
References: <48A400EC.9040407@redhat.com> <48A9AE88.3060507@goop.org>
In-Reply-To: <48A9AE88.3060507@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Chris Lalancette wrote:
>> Jeremy,
>>      Until recently, the maximum number of xvd block devices you could attach to
>> a Xen domU was 16.  This limitation turned out to be problematic for some users,
>> so it was expanded to handle a much larger number of disks.  However, this
>> requires a couple of changes in the way that blkfront scans for disks.  This
>> functionality is already present in the Xen linux-2.6.18-xen.hg tree; the
>> attached patch adds this functionality to the mainline xen-blkfront
>> implementation.
> 
> I haven't tested this yet.  You have tested it OK with some pvops
> kernel?  If so, send it to Jens Axboe with my ack.

Yes, I tested it with a 2.6.25-something Fedora 9 pv-ops kernel (i386).  I'll
send it along to Jens.

> 
>>   I successfully tested it on a 2.6.25 tree.  I build tested it
>> on 2.6.27-rc3, but couldn't get that tree to boot due to some other bug.
> 
> What other bug?

This is http://bugzilla.redhat.com/show_bug.cgi?id=459067, that I think you've
already looked at.  Basically any F-10 or upstream git kernel is crashing on an
i386 RHEL-5 HV.  We were a little confused by your comment in that bug, however;
we were under the impression that the fix you mentioned was specifically a
32-on-64 fix, not for 32-on-32.  If we were wrong, please point it out.

Thanks,
Chris Lalancette
