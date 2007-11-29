Return-Path: <linux-kernel-owner+w=401wt.eu-S1761293AbXK2Jwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761293AbXK2Jwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 04:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756215AbXK2Jwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 04:52:32 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:64281 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbXK2Jwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 04:52:31 -0500
Message-ID: <474E8BDC.4080403@fr.ibm.com>
Date: Thu, 29 Nov 2007 10:52:28 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch -mm 0/4] mqueue namespace
References: <20071128163728.177495768@fr.ibm.com>> <474DA549.6060408@openvz.org>
In-Reply-To: <474DA549.6060408@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov wrote:
> Cedric Le Goater wrote:
>> Hello ! 
>>
>> Here's a small patchset introducing a new namespace for POSIX
>> message queues. 
>>
>> Nothing really complex a part from the mqueue filesystem which 
>> needed some special care
> 
> Hm... Why did you decided to make it separately from the
> IPC namespace?

Mostly because it has its own configuration option and filesystem
which requires to clone also the mnt namespace.  

but yes they could probably be merged. Let's see what the others 
have to say about it.

C.
