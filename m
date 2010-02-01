Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab0BABoM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 20:44:12 -0500
Received: from mail-yx0-f196.google.com ([209.85.210.196]:58873 "EHLO
	mail-yx0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab0BABoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 20:44:10 -0500
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Jan 2010 20:44:10 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aDjDmaxZ7XmMEc8zTuuI+nlYtVZbkaIQzSTvBhLcywsWw8H2uBeOtfISHdQlBqzYJ/
         1lAmOTGe2lLkBHnX/0tbKRO3cuSZ0EVW/qO3yGimCBQZUoGaPquJ231GR6Lxz2w10DGG
         T35tR8nBKm8YmjpVHnu45/DagsE7C9GECP1F4=
Message-ID: <4B6630CA.9010207@gmail.com>
Date: Sun, 31 Jan 2010 17:39:22 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14487] PANIC: early exception 08 rip 246:10 error ffffffff810251b5
 cr2 0
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <de962C6zBxL.A.H1G.1HiZLB@chimera>
In-Reply-To: <de962C6zBxL.A.H1G.1HiZLB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/10 16:43, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14487
> Subject		: PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
> Submitter	: Justin P. Mattock<justinmattock@gmail.com>
> Date		: 2009-10-23 16:45 (101 days old)
> References	: http://lkml.org/lkml/2009/10/23/252
>
>
>


yeah still hitting this.
looking at the issue if I change:

@@ 260

if ((class == 0xffffffff))
	continue;
to

if ((class == 0xffffffff || 0xffffffffffffffff))
	continue;

I'm able to boot, but don't have enough knowledge to know
what is really happening(or how to execute this).
will continue looking at this
(hopefully I get somewhere on this);

Justin P. Mattock
