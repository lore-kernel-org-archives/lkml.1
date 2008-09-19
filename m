Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbYISMI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbYISMI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 08:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbYISMIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 08:08:49 -0400
Received: from nebensachen.de ([195.34.83.29]:59429 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbYISMIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 08:08:48 -0400
X-Hashcash: 1:20:080919:grundler@google.com::BLfZIt+kInvUTzD1:0000000000000000000000000000000000000000007TzO
X-Hashcash: 1:20:080919:bzolnier@gmail.com::PBGOn83w9mre7KAn:0000000000000000000000000000000000000000000BhI6
X-Hashcash: 1:20:080919:jeff@garzik.org::QQYYey/khq6T31UX:0029Dz
X-Hashcash: 1:20:080919:randy.dunlap@oracle.com::SOfjnQXo8DxxaeMr:0000000000000000000000000000000000000047sm
X-Hashcash: 1:20:080919:htejun@gmail.com::/5Wzs1F2MqptB3A1:07DkE
X-Hashcash: 1:20:080919:linux-ide@vger.kernel.org::v13xdfNKgOkSHHPA:0000000000000000000000000000000000001Es7
X-Hashcash: 1:20:080919:linux-kernel@vger.kernel.org::cMQtftRvQHk2tgdj:0000000000000000000000000000000000BqK
From: Elias Oltmanns <eo@nebensachen.de>
To: "Grant Grundler" <grundler@google.com>
Cc: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Jeff Garzik" <jeff@garzik.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Tejun Heo" <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4 v2] Add documentation for hard disk shock protection interface
References: <87d4j2n3dn.fsf@denkblock.local>
	<20080917163145.9870.8575.stgit@denkblock.local>
	<da824cf30809182121g1e68075dq6816522ba239e689@mail.gmail.com>
Date: Fri, 19 Sep 2008 14:08:26 +0200
Message-ID: <874p4cmj7p.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Grant Grundler" <grundler@google.com> wrote:
> I found one typo here...can be fixed up by hand I think.
>
> On Wed, Sep 17, 2008 at 9:40 AM, Elias Oltmanns <eo@nebensachen.de> wrote:
[...]
>> +1. Intro
>> +--------
>> +
>> +ATA/ATAPI-7 specifies the IDLE IMMEDIATE command with unload feature.
>> +Issuing this command should cause the drive to switch to idle mode and
>> +unload disk heads. This feature is being used in modern laptops in
>> +conjunction with accelerometers and appropriate software to implement
>> +a shock protection facility. The idea is to stop all I/O operations on
>> +the internal hard drive and park its heads on the ramp when critical
>> +situations are anticipated. The desire to have such a feature
>> +available on GNU/Linux systems has been the original motivation to
>> +implement a generic disk head parking interface in the Linux kernel.
>> +Please note, however, that other components have to be set up on your
>> +system in order to get disk shock protection working (see section
>> +3. References below for pointers to more information about that).
>
> Unfortunate place for a line break: "section 3" should be on one line if
> possible. Otherwise the "3. References" looks like section header with
> mangled white space (at first glance).

Quite right, I moved the word section to the next line as well.

[...]
>> +attached to any single port. In SATA world we have port multipliers
>> +which means that a user issued head parking request to one device may
>> +actually result in stopping I/O to a whole bunch of devices. Hwoever,
>
> Typo: However

Thanks.

[...]
>> +3. References
>> +-------------
>> +
>> +There are several laptops from different vendors featuring shock
>> +protection capabilities. As manufacturers have refused to support open
>> +source development of the required software components so far, Linux
>> +support for shock protection varies considerably between different
>> +hardware implementations. Ideally, this section should contain a list
>> +of pointers at different projects aiming at an implementation of shock
>> +protection on different systeems. Unfortunately, I only know of a
>> +single project which, although still considered experimental, is fit
>> +for use. Please feel free to add projects that have been the victims
>> +of my ignorance.
>> +
>> +- http://www.thinkwiki.org/wiki/HDAPS
>> +  See this page for information about Linux support of the hard disk
>> +  active protection system as implemented in IBM/Lenovo Thinkpads.
>> +  (FIXME: The information there will have to be updated once this
>> +  patch has been approved or the user interface has been agreed upon
>> +  at least.)
>
> Does this still belong here?

Even though it is still true, it probably doesn't belong here. Since
Bart has stuck this into his quilt tree, he can easily apply an
inter-diff. I won't send the patch just yet though because this remark
is a useful heads up for linux-next until the userspace daemon has been
updated and the website reflects all those changes. Of course, I'll try
to make sure that this is sorted out before the patch goes into
mainline, i.e. when the merge window is opened.

Thanks for reviewing,

Elias
