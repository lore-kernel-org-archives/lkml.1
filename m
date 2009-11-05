Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476AbZKEMIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbZKEMIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 07:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbZKEMIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 07:08:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158AbZKEMIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 07:08:20 -0500
Message-ID: <4AF2C000.3020807@redhat.com>
Date: Thu, 05 Nov 2009 13:07:28 +0100
From: Jan Safranek <jsafrane@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@free.fr>
CC: balbir@linux.vnet.ibm.com, libcg-devel <libcg-devel@lists.sourceforge.net>,
       "menage@google.com" <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       containers@lists.linux-foundation.org,
       Bharata B Rao <bharata.rao@in.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [RFC] Mount point suggestions for cgroup
References: <20091104063005.GC3560@balbir.in.ibm.com> <4AF1AF68.40704@free.fr>
In-Reply-To: <4AF1AF68.40704@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2009 05:44 PM, Daniel Lezcano wrote:
> Balbir Singh wrote:
>> Hi, All,
>>
>> We've been having a discussion as to what would be the right place to
>> mount the cgroup filesystem. Jan has been proactively looking into
>> this. The FHS has no recommendation since cgroup filesystem came in
>> much later.
>>
>> The options are
>>
>> 1. /dev/cgroup
>> 2. /cgroup
>> 3. Some place under /sys
>>
>> The problem with (2) is that it is quite non-standard and pollutes the
>> root directory. (3) requires some basic support to create a directory
>> for cgroup under /sys. (1) seems the most obvious choice since cpusets
>> were mounted under /dev/cpuset, but /dev is controlled by udev.
>>
>> Given the three choices or any other suggestions, is there a general
>> preference as to where we can mount it? The goal is to standardize
>> the mount point (if possible).
> Why the mount point has to be standardized ?
>

The mount point does not need to be set into stone so everybody *must* 
use it. I, as Fedora packager, just need some default place where to 
mount it, so applications which need to create/manage groups work 
without any (potentially dumb) user assistance. Of course, advanced 
admin can change the settings and move the groups anywhere, applications 
still need to parse /proc/mounts or use appropriate library like libcgroup.

Jan
