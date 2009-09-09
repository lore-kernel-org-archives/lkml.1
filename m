Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbZIIM24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbZIIM24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 08:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbZIIM2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 08:28:55 -0400
Received: from mail-qy0-f194.google.com ([209.85.221.194]:42547 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbZIIM2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 08:28:55 -0400
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Sep 2009 08:28:55 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DgFKSzITBHbeXXhMZJgxlBM6MX7yK5+ZabhMPs1RGpmv0YZovu1C/bmi0/TeJSd/gK
         TR4jzntpDUPTHdzrDobxtUnLxoDaHCgOde11u9HQPJY40kBTHhqu8z24C9+cckorafhe
         C+G4YEYwub3HbOr/OqcldKZXQJYYMl2ZthtAs=
Message-ID: <4AA79E4F.7010900@gmail.com>
Date: Wed, 09 Sep 2009 14:23:43 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-8.5 Thunderbird/3.0b3
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: rjw@sisk.pl, laijs@cn.fujitsu.com, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/1] sched: fix cpu_down deadlock
References: <4AA0FEBF.7040104@gmail.com>	 <1252496510-11898-1-git-send-email-jirislaby@gmail.com> <1252497225.7235.3.camel@laptop>
In-Reply-To: <1252497225.7235.3.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2009 01:53 PM, Peter Zijlstra wrote:
> On Wed, 2009-09-09 at 13:41 +0200, Jiri Slaby wrote:
>> Jiri Slaby wrote:
>>> Thanks, in the end I found it manually. Goddammit! It's an -mm thing:
>>> cpu_hotplug-dont-affect-current-tasks-affinity.patch
> 
> Is there a git tree with -mm in some place? I can't seem to find that
> patch in my inbox.
> 
> All I can find is some comments from Oleg that the patch looks funny.

Yes, here:
git://git.zen-sources.org/zen/mmotm.git

Actually I found Oleg came up with better solution to add
move_task_off_dead_cpu to take_cpu_down.

A discussion regarding this is at:
http://lkml.indiana.edu/hypermail/linux/kernel/0907.3/02278.html

So what's the status of the patches, please?
