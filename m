Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbYKFAso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbYKFAso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 19:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754588AbYKFAsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 19:48:33 -0500
Received: from smtp-out.google.com ([216.239.33.17]:14604 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbYKFAsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 19:48:32 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=ZL9HcFpdaHziPvfQxztXioRb7DcXOjLBSRlNdyJ3nLJ8CBErpe8bB8VqI7g23hepZ
	xR5anW/gKKMDjywFBR/8Q==
MIME-Version: 1.0
In-Reply-To: <4910014F.4000808@cn.fujitsu.com>
References: <20080811235323.872291138@us.ibm.com>
	 <20080811235325.121356317@us.ibm.com>
	 <6599ad830811032143h51eae533k5b0c17e65a7fa675@mail.gmail.com>
	 <490FE7B5.8020400@cn.fujitsu.com>
	 <6599ad830811032240n640f3fao48f1a9f05892b797@mail.gmail.com>
	 <490FFB56.7030300@cn.fujitsu.com>
	 <6599ad830811032356g6827a97dq41dec492fed8de15@mail.gmail.com>
	 <4910014F.4000808@cn.fujitsu.com>
Date: Wed, 5 Nov 2008 16:48:26 -0800
Message-ID: <6599ad830811051648i72c2c585s4ee803e030c798ad@mail.gmail.com>
Subject: Re: [RFC][PATCH] freezer_cg: disable writing freezer.state of root 
	cgroup
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2008 at 12:01 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Paul Menage wrote:
>> On Mon, Nov 3, 2008 at 11:35 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>>> With this change, the root cgroup is unfreezable, and writing to
>>> its freezer.state returns -EIO.
>>
>> EINVAL might be more consistent with other systems like cpusets.
>>
>
> Because writing FREEZE (or other invalid value) to freezer.state returns EIO..
>
> Or that EIO should be also changed to EINVAL.

Yes, I think that should be EINVAL too - seems more consistent.

Paul
