Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbYHZIYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbYHZIYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbYHZIYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:24:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43562 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbYHZIYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:24:34 -0400
To: jassi_singh_brar@yahoo.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: An idea .... with code
From: Andi Kleen <andi@firstfloor.org>
References: <801995.65435.qm@web33201.mail.mud.yahoo.com>
Date: Tue, 26 Aug 2008 10:24:30 +0200
In-Reply-To: <801995.65435.qm@web33201.mail.mud.yahoo.com> (jassi brar's message of "Sun, 24 Aug 2008 01:53:20 -0700 (PDT)")
Message-ID: <87tzd89oap.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jassi brar <jassi_singh_brar@yahoo.com> writes:

>   Lately a question has been bugging me: Why do we keep complicated(specific ioctls to set up and set free) 

Can you please expand a bit why you think losetup is that complicated
and what the problem is with it?

AFAIK you're essentially just moving a minimal version of losetup
(with missing features like no offsets etc.) into the kernel and
frankly I fail to see the beauty in that. Or rather if you start with
losetup, why stop at mount, modprobe, ifconfig, mkfs, fsck, ls[1], ...?

For me it seems more that most of the file system based command
interfaces (/proc/mtrr comes to mind) are quite hard to use and
I prefer a proper command line tool with a manpage and --help
and a real parser any day.

-Andi

[1] I'm sure someone could come up with some scheme to do ls using sysfs 
and you could find someone on this list who said "cool" :)

