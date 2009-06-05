Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbZFELJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbZFELJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 07:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbZFELI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 07:08:56 -0400
Received: from smtp.nokia.com ([192.100.105.134]:36417 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbZFELIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 07:08:55 -0400
Message-ID: <4A28FC8F.5020802@nokia.com>
Date: Fri, 05 Jun 2009 14:07:59 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>, axboe@kernel.dk,
       hirofumi@mail.parknet.co.jp, linux-ext4@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       adrian.hunter@nokia.com
Subject: Re: [PATCH 0/4] FS: userspace notification of errors
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com> 	<20090603115611.6bbbaf55.akpm@linux-foundation.org> <ac3eb2510906040553j294f1015wfb7deb4b4fc63afc@mail.gmail.com>
In-Reply-To: <ac3eb2510906040553j294f1015wfb7deb4b4fc63afc@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 Jun 2009 11:08:02.0334 (UTC) FILETIME=[E49D4BE0:01C9E5CD]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> And I don't think we want several event sources for the same thing,
> uevents _and_ pollable sysfs files.
> 
> We already raise events on /proc/self/mountinfo when the mount tree
> changes, I guess that's where fs specific stuff belongs, and it will
> work with all kind of filesystem setups, regardless of the devices
> below it. This is also the established interface for flags and options
> and the current state of the filesystem, and does not mix filesystem
> options into block device interfaces.
> 
> /proc/self/mountinfo could also work properly with namespaces which
> might have different meaning for a device in a different namespace.

Well, Denis suggests /sys/fs instead. But how would we pass stuff like
error code via /proc/self/mountinfo? And what if later some one wants
to provide user-space stuff like bogus inode number? IMO, /sys/fs
sounds better.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
