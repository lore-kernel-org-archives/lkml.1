Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab0BHBBO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 20:01:14 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:59199 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab0BHBBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 20:01:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pToKR6Oflj5Hkwru3t7G37LYgc1nIXbKGrVdUu44zmw49SmjL7YW284ws2eTdyWmZk
         8+VyGPSLqBSVMVezEx8+ys6w7o2IyB3JvAO8GT1b4YWPMVEar+ywIkY6JvPG3WJzqxnM
         iWIhEoCp13pjX0faZ2ZTdqcf74AyM5B0lQ49E=
Message-ID: <4B6F62BE.1090803@gmail.com>
Date: Sun, 07 Feb 2010 17:02:54 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [Bug #14487] PANIC: early exception 08 rip 246:10 error ffffffff810251b5
 cr2 0
References: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera> <iuJeop2ribM.A.mRC._a1bLB@chimera>
In-Reply-To: <iuJeop2ribM.A.mRC._a1bLB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/10 16:28, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14487
> Subject		: PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
> Submitter	: Justin P. Mattock<justinmattock@gmail.com>
> Date		: 2009-10-23 16:45 (108 days old)
> References	: http://lkml.org/lkml/2009/10/23/252
> Handled-By	: Jan Beulich<jbeulich@novell.com>
> Patch		: http://patchwork.kernel.org/patch/68719/
>
>
>


the patch attached to the bug report
makes my machine boot up with out a
Panic, and allows me to do remote debugging
via ohci1394_dma.

I did see a call trace as I was debugging
which might be related to having one
system using the patch, and the other not.
but still need to look at that.
(only saw this once out of numerous boots
(could be a rarity)).

Justin P. Mattock
