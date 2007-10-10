Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbXJJVSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbXJJVSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 17:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbXJJVSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 17:18:39 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42203 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbXJJVSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 17:18:38 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: Tejun Heo <htejun@gmail.com>, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCHSET 3/4] sysfs: divorce sysfs from kobject and driver model
References: <11902755392688-git-send-email-htejun@gmail.com>
	<20070925221736.GA3566@kroah.com> <46FB956B.8000205@gmail.com>
	<m1zlz7hpvn.fsf_-_@ebiederm.dsl.xmission.com>
	<20071005062302.GB16914@kroah.com>
	<m1d4vtn4jq.fsf@ebiederm.dsl.xmission.com>
	<20071009225139.GF21228@kroah.com>
	<m14pgzun27.fsf@ebiederm.dsl.xmission.com>
	<20071010204449.GA23680@kroah.com>
Date: Wed, 10 Oct 2007 15:16:57 -0600
In-Reply-To: <20071010204449.GA23680@kroah.com> (Greg KH's message of "Wed, 10
	Oct 2007 13:44:49 -0700")
Message-ID: <m1ir5ek6uu.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> Ah, ok, that makes more sense.
>
> And seems quite difficult to do, good luck with that :)

Thanks.   At least now all I have to do is worry about the
details when we get that far instead of selling the big picture...

My gut feel is that sysfs is probably the hardest part to deal with,
and maybe half of the problem.  Just intercepting the lookup by
device number is fairly simple, I think there is one spot
for block devices and another for character devices.

Anyway once the network namespace support is in with any luck that
will have solved half the sysfs problem.

Eric
