Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbYAQIaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbYAQIaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 03:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYAQIaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 03:30:00 -0500
Received: from def92-3-81-56-114-101.fbx.proxad.net ([81.56.114.101]:38755
	"EHLO barad-dur.regala.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbYAQI37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 03:29:59 -0500
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "rae l" <crquan@gmail.com>, open-iscsi@googlegroups.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC on MODULE SUPPORT] hello, Rusty, Should we provide module information even if the kernel module compiled built-in with bzImage?
References: <91b13c310801160202y833df7bs37cbb5827e875569@mail.gmail.com>
	<87fxwyhtim.fsf@barad-dur.regala.cx>
	<200801170915.26040.rusty@rustcorp.com.au>
From: Mathieu SEGAUD <mathieu.segaud@regala.cx>
Date: Thu, 17 Jan 2008 09:29:57 +0100
In-Reply-To: <200801170915.26040.rusty@rustcorp.com.au> (Rusty Russell's message of "Thu\, 17 Jan 2008 09\:15\:25 +1100")
Message-ID: <87tzlcg8hm.fsf@barad-dur.regala.cx>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vous m'avez dit récemment :

> On Wednesday 16 January 2008 22:58:09 Mathieu SEGAUD wrote:
>> your userspace program is somewhat broken
>> the userspace should not expect to find the version number in
>> /sys/module, as this is used by the Linux kernel module subsystem. You
>> should provide the required information in another way such as a
>> /proc/ file (bad) or a /sys file (better, but no module stuff, this
>> has no business with it).
>
> Shh!  He was going to implement a feature we want!
>
> To be honest, I think his expectations of consistency are correct: if a 
> version number makes sense, surely it makes sense for builtins as well.

yep, I did not look out the way he suggested to do it; and sure that
is a cool feature. sorry for that one. Sometimes it's difficult to
part what should be done _in_ the kernel, what should be done _by_ the
kernel, and userspace.

thanks a lot

-- 
Mathieu
