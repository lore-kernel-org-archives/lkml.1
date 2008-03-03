Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbYCCH2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbYCCH2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 02:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbYCCH2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 02:28:43 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44355 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbYCCH2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 02:28:42 -0500
Message-ID: <47CBA787.8020100@cn.fujitsu.com>
Date: Mon, 03 Mar 2008 16:23:51 +0900
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Xpl++ <xpl@amln.net>
CC: Paul Menage <menage@google.com>,
       Linux Containers <containers@lists.osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelianov <xemul@openvz.org>, Paul Jackson <pj@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Prefixing cgroup generic control filenames with "cgroup."
References: <6599ad830802281314s25c033d6tc021725ae28aef8d@mail.gmail.com> <47C7EEAC.7010907@amln.net>
In-Reply-To: <47C7EEAC.7010907@amln.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xpl++ wrote:
> Paul Menage ??????:
>> ...
>>
>> A compromise might be to keep "tasks" unprefixed, and say that future
>> names get the "cgroup." prefix; in this case I'd be inclined to add
>> the prefix to notify_on_release and release_agent on the grounds that
>> there's much less chance of breaking anyone with those files since (I
>> suspect) they're much less used.
>>   
> This makes most sense to me. It won't break any existing software 
> (most likely) while it seems reasonable to leave 'tasks' unprefixed as 
> this is something that any software using any subsystem of cgroup 
> would be using anyway and it is not that much associated with a 
> particulat subsystem.
>

And it makes most sense to me too, though I still doubt name collision 
will be a problem.

