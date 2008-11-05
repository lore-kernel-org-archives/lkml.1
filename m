Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbYKEKVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbYKEKVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 05:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754870AbYKEKUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 05:20:40 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:36254 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbYKEKUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 05:20:38 -0500
Message-ID: <4911730E.2050900@fr.ibm.com>
Date: Wed, 05 Nov 2008 11:18:54 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Paul Menage <menage@google.com>, Matt Helsley <matthltc@us.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [RFC][PATCH] freezer_cg: disable writing freezer.state of root
 	cgroup
References: <20080811235323.872291138@us.ibm.com>	 <20080811235325.121356317@us.ibm.com>	 <6599ad830811032143h51eae533k5b0c17e65a7fa675@mail.gmail.com>	 <490FE7B5.8020400@cn.fujitsu.com>	 <6599ad830811032240n640f3fao48f1a9f05892b797@mail.gmail.com>	 <490FFB56.7030300@cn.fujitsu.com> <6599ad830811032356g6827a97dq41dec492fed8de15@mail.gmail.com> <4910014F.4000808@cn.fujitsu.com>
In-Reply-To: <4910014F.4000808@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello !

>> Or maybe just skip populating the file entirely for the root cgroup?
>> It's not useful if it can't be written and always returns the same
>> value.
> 
> I thought about this. I'll see which way Matt and Cedric prefer.

I think that Paul's suggestion of disabling the root freezer makes sense.

Thanks,

C.

