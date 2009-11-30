Return-Path: <linux-kernel-owner+w=401wt.eu-S1753058AbZK3RoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbZK3RoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 12:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbZK3RoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 12:44:14 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:56653 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbZK3RoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 12:44:11 -0500
Message-ID: <4B140386.8030702@nortel.com>
Date: Mon, 30 Nov 2009 11:40:22 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: using kernel headers in libc headers
References: <a36005b50911300837s6fe4da73s973ccbe7401b9989@mail.gmail.com> <4B13FA4E.1070901@zytor.com>
In-Reply-To: <4B13FA4E.1070901@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Nov 2009 17:42:23.0290 (UTC) FILETIME=[792C29A0:01CA71E4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2009 11:01 AM, H. Peter Anvin wrote:

> A better way is to factor out subsets; if <linux/sched.h> has too many
> things, we can break out the POSIX parts into <linux/sched_posix.h> or
> (certainly better if we have more than one of these)
> <linux/sched/posix.h> which can also be included by <linux/sched.h>.
> 
> glibc can then choose to include or not include <linux/sched/posix.h>
> depending on its configuration.  The configuration macros remain a glibc
> internal detail.

Yes, absolutely.  Personally I find it much easier to open a separate
header file than to read code that is littered with #ifdefs.

Chris
