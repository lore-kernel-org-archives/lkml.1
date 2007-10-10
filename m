Return-Path: <linux-kernel-owner+w=401wt.eu-S1756013AbXJJRYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbXJJRYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 13:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbXJJRYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 13:24:47 -0400
Received: from dvhart.com ([64.146.134.43]:47125 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612AbXJJRYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 13:24:47 -0400
Message-ID: <470D0ADB.2060007@mbligh.org>
Date: Wed, 10 Oct 2007 10:24:43 -0700
From: Martin Bligh <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: Tejun Heo <htejun@gmail.com>, ebiederm@xmission.com,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 3/4] sysfs: divorce sysfs from kobject and driver	model
References: <11902755392688-git-send-email-htejun@gmail.com> <20070925221736.GA3566@kroah.com> <46FB956B.8000205@gmail.com> <20071005061812.GA16914@kroah.com> <4705EF30.8010002@gmail.com> <20071009224820.GE21228@kroah.com>
In-Reply-To: <20071009224820.GE21228@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The rules for sysfs files are the following:
> 	- one value, in text format, per file.
> 	- no action apon open/close
> 	- binary files are only allowed for "pass-through" type files
> 	  that the kernel does not touch (like for firmware and pci
> 	  config space)
> 	- directories should be associated with a kobject where it makes
> 	  sense (no nesting deep subdirectories without a kobject
> 	  present)
> 	- when a directory is created/removed, a uevent should happen
> 	  declaring what type of device was created/removed.

So you'll be removing:

/sys/devices/system/node/node?/meminfo

then?

along with:

/sys/devices/system/node/node?/distance
/sys/devices/system/node/node?/numastat

and all the other things that violate the rules?

(which I do agree with ... I just don't think sysfs works for
performance stats as we've discussed several times before ;-))

M.
