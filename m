Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbZD0OHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbZD0OHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 10:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZD0OHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 10:07:41 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:57525 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbZD0OHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 10:07:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ue/zqYJQxEVOpWnJRow3+TTiDPno6TzxHxI7RKVmg1wm/vxA0eZjsjDTqocMcK6jh6
         x7ijhBfZOLFBVDdQVeQLSJgT2ngBfOnDWYVY74cCf2LqUDfRBIwhq0Y+jaYXXPQDyApy
         oR05duUkwqRJKYPvmNUFcQstFs9mgFtEmFdHE=
MIME-Version: 1.0
In-Reply-To: <40a4ed590904270639y2e1d29aaud7d66164d22e4e6b@mail.gmail.com>
References: <40a4ed590904240309o66753264lf58f2910726f7efc@mail.gmail.com>
	 <alpine.DEB.2.00.0904241011280.24151@chino.kir.corp.google.com>
	 <40a4ed590904241113p4949a020y46e0641e77f6f4e3@mail.gmail.com>
	 <alpine.DEB.2.00.0904241155550.26080@chino.kir.corp.google.com>
	 <40a4ed590904241216u655300ddvaa4660e11ad2cffc@mail.gmail.com>
	 <alpine.DEB.2.00.0904241224001.28589@chino.kir.corp.google.com>
	 <40a4ed590904250132o63e715cbvaccf5aac82265cd@mail.gmail.com>
	 <alpine.DEB.2.00.0904261252010.18988@chino.kir.corp.google.com>
	 <407d949e0904270635p7f87e3c3jcb1db0e61d4ed11e@mail.gmail.com>
	 <40a4ed590904270639y2e1d29aaud7d66164d22e4e6b@mail.gmail.com>
Date: Mon, 27 Apr 2009 16:07:36 +0200
Message-ID: <40a4ed590904270707p3a777adcv1e22e89ec0e0a8d7@mail.gmail.com>
Subject: Re: Kernel 2.6.29 runs out of memory and hangs.
From: Zeno Davatz <zdavatz@gmail.com>
To: Greg Stark <gsstark@mit.edu>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
       Hannes Wyss <hwyss@ywesee.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 3:39 PM, Zeno Davatz <zdavatz@gmail.com> wrote:
> On Mon, Apr 27, 2009 at 3:35 PM, Greg Stark <gsstark@mit.edu> wrote:
>> On Sun, Apr 26, 2009 at 8:55 PM, David Rientjes <rientjes@google.com> wrote:
>>> There is work being done on a per-cgroup lowmem notifier which would allow
>>> userspace to poll() on a device file and be notified of low memory
>>> situations so that it can react on its own (like killing a low priority
>>> task, expanding a cpuset, increasing a memcontroller limit, etc.)
>>
>> Surely anything that important ought to be running with overcommit
>> disabled anyways.
>
> Where do I enable or disable overcommit?

Ok, I found this one as well:

Documentation/vm/overcommit-accounting

and

http://www.linuxdevcenter.com/pub/a/linux/2006/11/30/linux-out-of-memory.html?page=2

is a useful article for the beginner.

Best
Zeno
