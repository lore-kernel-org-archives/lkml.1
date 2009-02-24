Return-Path: <linux-kernel-owner+w=401wt.eu-S1758063AbZBXBlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbZBXBlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 20:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbZBXBlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 20:41:13 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54833 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753726AbZBXBlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 20:41:12 -0500
Message-ID: <49A35048.3000304@cn.fujitsu.com>
Date: Tue, 24 Feb 2009 09:41:28 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       menage@google.com, containers@lists.linux-foundation.org
Subject: Re: Question for remount
References: <20090220190223.e8b4f6a8.kamezawa.hiroyu@jp.fujitsu.com>	<49A20976.2050301@cn.fujitsu.com>	<49A21044.40402@cn.fujitsu.com> <20090224103659.069e6b33.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090224103659.069e6b33.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  To change the set of subsystems bound to a mounted hierarchy, just
>>  remount with different options:
>> +# mount -o remount,cpuset,ns hier1 /dev/cgroup
>>  
>> -# mount -o remount,cpuset,ns  /dev/cgroup
>> +Now numtasks is removed from the hierarchy and ns is added.
>> +
>> +Note this will add ns to the hierarchy but won't remove numtasks or
>> +cpuset:
>> +# mount -o remount,ns /dev/cgroup
>>  
> 
> Just a question. What is "numtasks" here ? We have numtasks cgroup ?
> 

No, I guess that's a proposed but not implemented cgroup subsystem. :)
And I can change it to an existing one.

