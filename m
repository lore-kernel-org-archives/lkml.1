Return-Path: <linux-kernel-owner+w=401wt.eu-S932860AbXAZKxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860AbXAZKxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 05:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932846AbXAZKxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 05:53:47 -0500
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:48611 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932860AbXAZKxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 05:53:46 -0500
Message-ID: <45B9DDB8.8010000@s5r6.in-berlin.de>
Date: Fri, 26 Jan 2007 11:53:44 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.0.8) Gecko/20061030 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Pete Zaitcev <zaitcev@redhat.com>
CC: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Juju
References: <20070124223745.33278eb4.zaitcev@redhat.com>	<45B91EAB.9080004@redhat.com>	<20070125153824.8d7f50c5.zaitcev@redhat.com>	<45B968E7.1070402@s5r6.in-berlin.de> <20070125204733.1ae70031.zaitcev@redhat.com>
In-Reply-To: <20070125204733.1ae70031.zaitcev@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pete Zaitcev wrote:
> On Fri, 26 Jan 2007 03:35:19 +0100, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> The target wrote an SBP-2 status block into our memory. The status block
>> contains the FireWire bus address of the ORB to which it belongs. [...]
> 
> I see. SRP has a more flexible tag which can be used to look up
> the just completed command more effectively. But if we only submit
> one, it's a moot point of course.

And indeed, in the SBP-2 realm the ORB's address is actually the tag of
the SCSI task.

>> [...] Since there aren't many
>> mapped ORBs per target, a linked list is a reasonable data structure to
>> search over.
> 
> Righto. I'm used to having thousands of oustanding commands in arrays.

If I ever get to fix sbp2's handling of dynamically appended ORB lists,
the next step would be to measure which queue depth is optimal for
different hardware and different workloads. (Certainly much less than
thousands for typical SBP-2 target(s)+initiator(s) setups.)
-- 
Stefan Richter
-=====-=-=== ---= ==-=-
http://arcgraph.de/sr/
