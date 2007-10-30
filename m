Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbXJ3ETx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbXJ3ETx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 00:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750920AbXJ3ETq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 00:19:46 -0400
Received: from il.qumranet.com ([82.166.9.18]:36426 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbXJ3ETq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 00:19:46 -0400
Message-ID: <4726B088.1010709@qumranet.com>
Date: Tue, 30 Oct 2007 06:18:16 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: David Brown <dmlb2000@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] 2.6.23.1-rt4 and kvm 48
References: <9c21eeae0710290709x527cf4fcq52bb410907ff496@mail.gmail.com>
In-Reply-To: <9c21eeae0710290709x527cf4fcq52bb410907ff496@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brown wrote:
> Uhm, not sure who to send this too...
>
> I thought I'd try out the realtime patch set and it didn't work at all
> with kvm. The console didn't dump anything and the system completely
> locked up.
>
> Anyone have any suggestions as to how to get more output on this issue?
>   

Make sure CONFIG_PREEMPT_NOTIFIERS is enabled. Jan Kiszka reported 
success with a similar configuration.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

