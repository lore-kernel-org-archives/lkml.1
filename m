Return-Path: <linux-kernel-owner+w=401wt.eu-S1752360AbZI2N33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbZI2N33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 09:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbZI2N33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 09:29:29 -0400
Received: from mtagate4.de.ibm.com ([195.212.17.164]:48736 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbZI2N32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 09:29:28 -0400
Message-ID: <4AC20BB8.4070509@free.fr>
Date: Tue, 29 Sep 2009 15:29:28 +0200
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, mingo@elte.hu, torvalds@linux-foundation.org,
       xemul@openvz.org
Subject: Re: [PATCH 00/80] Kernel based checkpoint/restart [v18]
References: <1253749920-18673-1-git-send-email-orenl@librato.com>	<20090924154139.2a7dd5ec.akpm@linux-foundation.org> <20090928163704.GA3327@us.ibm.com>
In-Reply-To: <20090928163704.GA3327@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting Andrew Morton (akpm@linux-foundation.org):
>   
>> On Wed, 23 Sep 2009 19:50:40 -0400
>> Oren Laadan <orenl@librato.com> wrote:
>>     
>>> Q: What about namespaces ?
>>> A: Currrently, UTS and IPC namespaces are restored. They demonstrate
>>>    how namespaces are handled. More to come.
>>>       
>> Will this new code muck up the kernel?
>>     

[ cut ]
> For network namespaces i think it's clearer that a wrapper
> program should set up the network for the restarted init task,
> while the usrspace code should recreate any private network
> namespaces and veth's which were created by the application.
> But it still needs discussion.
>   
Ok for the restart, but for the checkpoint, how do you access the 
network setup from a process which belongs to another namespace context ?

