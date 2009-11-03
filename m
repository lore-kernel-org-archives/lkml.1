Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbZKCHY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbZKCHY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 02:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755688AbZKCHYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 02:24:55 -0500
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:62987 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbZKCHYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 02:24:55 -0500
Message-ID: <4AEFDAAE.500@free.fr>
Date: Tue, 03 Nov 2009 08:24:30 +0100
From: Cedric Le Goater <legoater@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, andrea@cpushare.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Emelianov <xemul@openvz.org>, Alexey Dobriyan <adobriyan@mail.ru>,
       linux-kernel@vger.kernel.org
Subject: Re: pidns memory leak
References: <20091006040526.GA22923@us.ibm.com> <4ACAFD6A.3060008@fr.ibm.com>	<20091008030828.GA18973@us.ibm.com> <4ACD9ECC.90508@fr.ibm.com>	<20091009032928.GA2031@us.ibm.com> <4ACF381F.9050808@fr.ibm.com>	<20091010013235.GA11904@us.ibm.com> <4AD2EBC7.2020109@fr.ibm.com>	<20091014061533.GA23569@us.ibm.com>	<20091102133326.e3dc51fb.akpm@linux-foundation.org>	<20091102223818.GA15628@us.ibm.com> <20091102144752.71fd4a31.akpm@linux-foundation.org>
In-Reply-To: <20091102144752.71fd4a31.akpm@linux-foundation.org>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2009 11:47 PM, Andrew Morton wrote:
> On Mon, 2 Nov 2009 16:38:18 -0600
> "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> 
>>> This bug hasn't been fixed yet, has it?
>>
>> Well Suka did trace the bug to commit 7766755a2f249e7, and posted a patch
>> to revert that, acked by Eric on Oct 20.  Suka, were you going to repost
>> that patch?
> 
> Ah.  OK.  Thanks.  Found it in the backlog pile.

We've added the patch to our patchset and we confirm that the pid_* leaks have 
been reduced to 'nearly' nothing but we still have a lot of inodes and dentries
leaks. I hope to find some time to investigate and reproduce with a small 
scenario, we are running a LTP like testsuite in a container environment.

Also, Alexey had questions about it.

C.
