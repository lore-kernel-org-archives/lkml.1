Return-Path: <linux-kernel-owner+w=401wt.eu-S1760400AbXH3RlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760400AbXH3RlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 13:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758518AbXH3RlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 13:41:06 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44327 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757675AbXH3RlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 13:41:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Newall <david@davidnewall.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible fashion.
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com>
	<20070828230459.GA15937@infradead.org>
	<m1r6lnb4ha.fsf@ebiederm.dsl.xmission.com>
	<46D4CC81.4060400@zytor.com>
	<m1d4x7aysz.fsf@ebiederm.dsl.xmission.com>
	<20070829114604.242b976c@the-village.bc.nu>
	<m1absa5kid.fsf@ebiederm.dsl.xmission.com>
	<46D6C40A.9090504@davidnewall.com>
Date: Thu, 30 Aug 2007 11:40:51 -0600
In-Reply-To: <46D6C40A.9090504@davidnewall.com> (David Newall's message of
	"Thu, 30 Aug 2007 22:50:10 +0930")
Message-ID: <m18x7s2a58.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall <david@davidnewall.com> writes:

> Eric W. Biederman wrote:
>> This isn't "Oh some apps are using it let's get them to stop, because
>> it is inconvenient".  This is  "No apps seems to be using this, we
>> keep goofing up the maintenance and no one notices, and so it is
>> likely a source of security problems and other nasties"
>>
>
> This first claim is not consistent with the next claim:
>
>> I have evidence that there are 1 or 2 open source applications using
>> this (not counting the glibc weirdness).
>
> If may be unmaintainable but, apparently, it's not really unused.

Only in a strict mathematical sense.  I seem to recall patches to
those programs or seeing that it doesn't matter.  Things are sufficient
that I expect that in 2 years time when we revisit this.  We won't
be able to find anything that cares.

Eric
