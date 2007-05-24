Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbXEXW17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbXEXW17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbXEXW1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:27:47 -0400
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4249 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbXEXW1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:27:46 -0400
From: "Miquel van Smoorenburg" <miquels@cistron.nl>
To: facorread@gmail.com
Subject: Re: 2.6.22-rc2 and libata/shutdown
X-Newsgroups: lists.linux.kernel
In-Reply-To: <xs4all.4655FDEA.30209@gmail.com>
References: <xs4all.20070524102122.GA8652@localhost.localdomain>
Organization: 
Cc: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1HrLmU-0003XG-OM@n2o.xs4all.nl>
Date: Fri, 25 May 2007 00:27:38 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <xs4all.4655FDEA.30209@gmail.com> you write:
>Hello Damien, people...
>
>Damien Wyart wrote:
>> Hello,
>> 
>> After trying 2.6.22-rc2, I noticed the warning message from libata about
>> upgrading shutdown(8). First, I have two SATA disks, and get the warning for
>> only one of them. Second, I double-checked the source of shutdown for my
>> distro (Debian unstable), and do not see anything related to issueing
>> STANDBYNOW.
>
>The warning is pretty important, and you can check it at
>
>http://linux-ata.org/shutdown.html
>
>I have been checking the sysvinit sources and I cannot see the portions
>on scanning SCSI or SATA
>disks. I only see the IDE scanning and standby-related code at
>src/hddown.c. Does anybody know
>how in the world are the SATA disks put to sleep in userspace?

Standard sysvinit doesn't do this, but many distributions have
patched it so that it does.

Debian has patched it as well; if you unpack the debian
sources you won't see it right away though. The extra patches
are applied by the build process, patches are under debian/

Mike.
