Return-Path: <linux-kernel-owner+w=401wt.eu-S1761836AbXGJGnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761836AbXGJGnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 02:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbXGJGnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 02:43:05 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:28217 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbXGJGnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 02:43:03 -0400
Message-ID: <46932A41.20100@openvz.org>
Date: Tue, 10 Jul 2007 10:42:09 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Cedric Le Goater <clg@fr.ibm.com>
CC: Andrew Morton <akpm@osdl.org>, Kirill Korotaev <dev@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 2/16] Miscelaneous preparations for namespaces
References: <468DF6F7.1010906@openvz.org> <468DF76A.7060106@openvz.org> <469298F5.9090301@fr.ibm.com>
In-Reply-To: <469298F5.9090301@fr.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cedric Le Goater wrote:
> Pavel Emelianov wrote:
>> The most importaint change is moving exit_task_namespaces()
>> inside exit_notify() to makes it possible to notify the
>> exiting task's parent. However this should be done before
>> release_task() to address the issue pointed by Sukadev with
>> NFS kernel thread.
> 
> Have you actually checked that doing an unshare() with a NFS mount ?

Not unshare(), but clone(). I admit that I lost smth significant,
but everything was fine...

>> Other changes are small and do not deserve separate description.
> 
> yes. if they were in a separate patch, you could push them to -mm.

OK

> thanks,
> 
> C.
> 

