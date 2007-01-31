Return-Path: <linux-kernel-owner+w=401wt.eu-S1030563AbXAaT3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030563AbXAaT3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 14:29:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030564AbXAaT3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 14:29:07 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:48596 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030566AbXAaT3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 14:29:06 -0500
In-Reply-To: <1170240636.24358.41.camel@frg-rhel40-em64t-03>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <1170209044.26655.364.camel@localhost.localdomain> <Pine.LNX.4.64.0701301838110.3611@woody.linux-foundation.org> <Pine.LNX.4.64.0701301853190.3611@woody.linux-foundation.org> <1170240636.24358.41.camel@frg-rhel40-em64t-03>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <047B6126-F30E-46C6-8410-50935B71C8FD@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
Date: Wed, 31 Jan 2007 11:28:06 -0800
To: Xavier Bestel <xavier.bestel@free.fr>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 31, 2007, at 2:50 AM, Xavier Bestel wrote:

> On Tue, 2007-01-30 at 19:02 -0800, Linus Torvalds wrote:
>> Btw, this is also something where we should just disallow certain  
>> system
>> calls from being done through the asynchronous method.
>
> Does that mean that doing an AIO-disabled syscall will wait for all  
> in-
> flight AIO syscalls to finish ?

That seems unlikely.  I imagine we'd just return EINVAL or ENOSYS or  
something to that effect.

- z
