Return-Path: <linux-kernel-owner+w=401wt.eu-S1752427AbYAQM1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbYAQM1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 07:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755676AbYAQM0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 07:26:46 -0500
Received: from def92-3-81-56-114-101.fbx.proxad.net ([81.56.114.101]:33952
	"EHLO barad-dur.regala.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbYAQM0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 07:26:44 -0500
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, sct@redhat.com
Subject: Re: [PATCH] Convert EXT2 to use unlocked_ioctl
References: <1200565824-362-1-git-send-email-mathieu.segaud@regala.cx>
	<200801171254.04071.arnd@arndb.de>
	<87myr4ek82.fsf@barad-dur.regala.cx>
	<200801171318.57491.arnd@arndb.de>
From: Mathieu SEGAUD <mathieu.segaud@regala.cx>
Date: Thu, 17 Jan 2008 13:26:42 +0100
In-Reply-To: <200801171318.57491.arnd@arndb.de> (Arnd Bergmann's message of "Thu\, 17 Jan 2008 13\:18\:56 +0100")
Message-ID: <87abn4eiyl.fsf@barad-dur.regala.cx>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vous m'avez dit récemment :

> On Thursday 17 January 2008, Mathieu SEGAUD wrote:
>> yep, they do. I noticed this nested calls. I guess I will add
>> _extX_compat_ioctl() running with no BKL's which would be used by both
>> extX_ioctl() and extX_compat_ioctl().
>> Any comments on such a strategy ? thanks a lot for the reminder :)
>> 
>
> Why not just kill the lock_kernel() in extX_compat_ioctl() ?

sure, I just posted I wasn't that awake enough to see this one :)
by the way thanks for the heads up.
I repost the whole thing corrected.

-- 
Mathieu
