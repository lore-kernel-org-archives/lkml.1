Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbZC3XIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbZC3XIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 19:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbZC3XHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 19:07:55 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:35250 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZC3XHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 19:07:55 -0400
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc 1/6: implement support for automounts in task directories
References: <20090330225326.GB19892@x200.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 30 Mar 2009 16:07:49 -0700
In-Reply-To: <20090330225326.GB19892@x200.localdomain> (Alexey Dobriyan's message of "Tue\, 31 Mar 2009 02\:53\:26 +0400")
Message-ID: <m11vseip8a.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: adobriyan@gmail.com, linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> writes:

> I don't have a lot of opinion on this bug. I checked patchset to fix known
> reproducer, timeout is obviously taken out of air and not nice.
>
> 6/6 looks orthogonal to whole patch series, CCing Andreas just in case.

It is orthogonal.  I happened to notice it, when I was doing the other work.

If you review the code path where proc entries go away to understand
the mount expiry in proc.  proc_flush_task is part of that code path.

Eric
