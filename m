Return-Path: <linux-kernel-owner+w=401wt.eu-S1754111AbYKDIEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbYKDIEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 03:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbYKDIEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 03:04:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57434 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753298AbYKDIEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 03:04:14 -0500
Message-ID: <4910014F.4000808@cn.fujitsu.com>
Date: Tue, 04 Nov 2008 16:01:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Matt Helsley <matthltc@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [RFC][PATCH] freezer_cg: disable writing freezer.state of root
 	cgroup
References: <20080811235323.872291138@us.ibm.com>	 <20080811235325.121356317@us.ibm.com>	 <6599ad830811032143h51eae533k5b0c17e65a7fa675@mail.gmail.com>	 <490FE7B5.8020400@cn.fujitsu.com>	 <6599ad830811032240n640f3fao48f1a9f05892b797@mail.gmail.com>	 <490FFB56.7030300@cn.fujitsu.com> <6599ad830811032356g6827a97dq41dec492fed8de15@mail.gmail.com>
In-Reply-To: <6599ad830811032356g6827a97dq41dec492fed8de15@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Mon, Nov 3, 2008 at 11:35 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> With this change, the root cgroup is unfreezable, and writing to
>> its freezer.state returns -EIO.
> 
> EINVAL might be more consistent with other systems like cpusets.
> 

Because writing FREEZE (or other invalid value) to freezer.state returns EIO..

Or that EIO should be also changed to EINVAL.

> Or maybe just skip populating the file entirely for the root cgroup?
> It's not useful if it can't be written and always returns the same
> value.
> 

I thought about this. I'll see which way Matt and Cedric prefer.

