Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbZKPXah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbZKPXah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbZKPXag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:30:36 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:56822 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbZKPXae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:30:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LMqo5D8kW6NGVCKc4mC2mF4H3utdiaqvTnIVKG9ytvlenWHr9pgcS4/SwEyiwxkSlY
         UMH3qdvNJIfw3n+6dJvDyf3UwzSlSpGhB07Z1ClkAw/iq1yqyoGiM8+YAZwU71q1RK0o
         pN3yaNKXdi6IUMDXfRrXzio3wuF5+4khsougI=
Message-ID: <4B01E09D.3020608@lwfinger.net>
Date: Mon, 16 Nov 2009 17:30:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Subject: Re: 2.6.32-rc7-git1: Reported regressions 2.6.30 -> 2.6.31
References: <ipicVA1QUFF.A.zWB.1mdALB@chimera>
In-Reply-To: <ipicVA1QUFF.A.zWB.1mdALB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2009 04:58 PM, Rafael J. Wysocki wrote:
> This message contains a list of some regressions introduced between 2.6.30 and
> 2.6.31, for which there are no fixes in the mainline I know of.  If any of them
> have been fixed already, please let me know.
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14181
> Subject		: b43 causes panic at ifconfig down / shutdown
> Submitter	: Jeremy Huddleston <jeremyhu@freedesktop.org>
> Date		: 2009-09-15 18:34 (63 days old)

This one is fixed by commit d50bae33d1358b909ade05ae121d83d3a60ab63f in
mainline. The patch was also sent to stable.

Larry
