Return-Path: <linux-kernel-owner+w=401wt.eu-S1758861AbXHBST6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbXHBST6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 14:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbXHBSTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 14:19:51 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58451 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbXHBSTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 14:19:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <htejun@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: 2.6.23-rc1-mm2: Fix crash in sysfs_hash_and_remove
References: <20070731230932.a9459617.akpm@linux-foundation.org>
	<200708021931.58123.rjw@sisk.pl> <46B2158F.4060302@gmail.com>
Date: Thu, 02 Aug 2007 12:19:11 -0600
In-Reply-To: <46B2158F.4060302@gmail.com> (Tejun Heo's message of "Fri, 03 Aug
	2007 02:34:07 +0900")
Message-ID: <m1ps25n6jk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> writes:

> Rafael J. Wysocki wrote:
>> From: Rafael J. Wysocki <rjw@sisk.pl>
>> 
>> My test box crashes during suspend, while the nonboot CPUs are being disabled,
>> because sysfs_hash_and_remove() doesn't check if dir_sd passed to it is not
>> NULL.  Fix it.
>> 
>> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>
> It got broken when shadow support was added.  The shadow support in -mm1
> will be dropped and Eric is preparing a new version.  So, this fix
> probably won't be necessary from -mm2.

Agreed.  That check is in my current development tree.

Eric
