Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbZEWLgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbZEWLgY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 07:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbZEWLgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 07:36:09 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:46289 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbZEWLgI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 07:36:08 -0400
MIME-Version: 1.0
In-Reply-To: <m17i08jpk8.fsf@fess.ebiederm.org>
References: <m1bppofm9k.fsf@fess.ebiederm.org> <1242865694-2100-4-git-send-email-ebiederm@xmission.com> 
	<4A14F356.3030501@kernel.org> <m1k54a7w2x.fsf@fess.ebiederm.org> 
	<4A15046A.10106@kernel.org> <m1octm287f.fsf@fess.ebiederm.org> 
	<4A1512E2.2040505@kernel.org> <m1vdnuyftb.fsf@fess.ebiederm.org> 
	<4A151ECE.50800@kernel.org> <m17i08jpk8.fsf@fess.ebiederm.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 23 May 2009 13:35:48 +0200
Message-ID: <ac3eb2510905230435n20dc376cw95e10eb2cb0cfecb@mail.gmail.com>
Subject: Re: [PATCH 04/20] sysfs: Handle the general case of removing of 
	directories with subdirectories
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 23, 2009 at 08:33, Eric W. Biederman <ebiederm@xmission.com> wrote:

> My plan going forward is to fix the ordering problems with deleting
> /sys/dev/char and /sys/dev/block.  Add a WARN_ON if we delete a
> non-empty directory.  Ensure we don't add something to an already
> deleted directory.

What's the problem in /sys/dev/? There are just a bunch of symlinks,
one for every device with a dev_t, and all in flat directories, and no
directory to remove.

Thanks,
Kay
