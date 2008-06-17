Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbYFQNRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbYFQNRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 09:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757211AbYFQNRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 09:17:08 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:10208 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198AbYFQNRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 09:17:02 -0400
Message-ID: <4857B92F.9020309@codemonkey.ws>
Date: Tue, 17 Jun 2008 08:16:31 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Martin Michlmayr <tbm@cyrius.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Linux with kvm-intel locks up VMplayer guest is started
References: <20080616150550.GA16086@deprecation.cyrius.com> <48568503.90607@codemonkey.ws> <20080617123918.GA2397@deprecation.cyrius.com>
In-Reply-To: <20080617123918.GA2397@deprecation.cyrius.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Michlmayr wrote:
> * Anthony Liguori <anthony@codemonkey.ws> [2008-06-16 10:21]:
>   
>>> Any idea if this is a kernel bug, BIOS issue or a bug in VMplayer?
>>>       
>> This has been fixed in the latest KVM code base AFAIK.
>>     
>
> Can you give some more information?  Which commit fixed the problem?
>   

commit 1f4e1d64122369d65d8a9c616112780019fb6188
Author: Eli Collins <ecollins@vmware.com>
Date:   Sun Jun 1 20:24:40 2008 -0700

> Was the patch submitted to the 2.6.25-stable tree?
>   

No, it's not a regression.  I misread your first email btw, you have to 
unload the kvm-intel kernel module to use VMware.

VMware is a binary kernel module that's out of kernel.  KVM is not 
misbehaving and the fact that VMware breaks when the KVM module is 
loaded isn't our problem.  If they submitted their code for inclusion in 
mainline, we could possibly come up with solution for arbitrating who is 
using VT.

Regards,

Anthony Liguori
