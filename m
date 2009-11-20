Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbZKTPu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbZKTPu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 10:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZKTPu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 10:50:56 -0500
Received: from mxout-08.mxes.net ([216.86.168.183]:51072 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbZKTPuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 10:50:55 -0500
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: linux-kernel@vger.kernel.org, lrodriguez@atheros.com
Cc: sam@ravnborg.org, greg@kroah.com, akpm@linux-foundation.org,
       mcgrof@gmail.com
Subject: [PATCH 0/4] kconfig: streamline_config.pl: optionally accept lsmod output
Date: Fri, 20 Nov 2009 15:50:50 +0000
Message-Id: <1258732254-15573-1-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/09, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:
> On Fri, Nov 13, 2009 at 04:02:04AM -0800, Alan Jenkins wrote:
>> On 11/13/09, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:
>> > On Thu, Nov 12, 2009 at 3:31 PM, Alan Jenkins
>> > <sourcejedi.lkml@googlemail.com> wrote:
>> >> On 11/12/09, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:
>> >>>
>> >>> The new 'make localmodconfig' proves very useful but on low end
>> >>> systems we do not want to 'git clone' an entire kernel tree or
>> >>> download a whole kernel but just cross compile the kernel on a
>> >>> bigger machine. The .config generated with 'make localmodconfig'
>> >>> is still very helpfup though
>> >>
>> >> When I tried this for my netbook, my approach was to copy
>> >> /proc/modules and /boot/config from the netbook.  As a shameless hack,
>> >> I temporarily bind mounted /proc/modules on the build system.  I guess
>> >> the cleaner way would be to copy the result of "lsmod", and have
>> >> localmodconfig accept "LSMOD_FILE=file".
>> >>
>> >> Naturally I think my approach is simpler, despite not having actually
>> >> implemented it properly :).  What do you think about it?
>
> Patches welcomed :)

Here goes :).  The first three patches are unrelated fixes.  Patch 4 implements
"make localmodconfig MODULES_LIST=lsmod.out".

1. kconfig: streamline_config.pl: "use strict" (and fix the errors)
2. kconfig: streamline_config.pl: fix out-of-tree builds
3. kconfig: streamline_config.pl: add handling for "if" statements in Kconfig
4. kconfig: streamline_config.pl: optionally accept lsmod output

Regards
Alan

