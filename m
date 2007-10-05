Return-Path: <linux-kernel-owner+w=401wt.eu-S1762793AbXJENCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762793AbXJENCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 09:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756654AbXJENCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 09:02:00 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39647 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516AbXJENB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 09:01:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, vgoyal@in.ibm.com, k-miyoshi@cb.jp.nec.com,
       kexec@lists.infradead.org, Bernhard Walle <bwalle@suse.de>,
       Keith Owens <kaos@ocs.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, kdb@oss.sgi.com
Subject: Re: [PATCH 0/2] add new notifier function
References: <4704D09D.6080503@ah.jp.nec.com>
Date: Fri, 05 Oct 2007 07:01:17 -0600
In-Reply-To: <4704D09D.6080503@ah.jp.nec.com> (Takenori Nagano's message of
	"Thu, 04 Oct 2007 20:38:05 +0900")
Message-ID: <m1641llnqa.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Takenori Nagano <t-nagano@ah.jp.nec.com> writes:

> Hi,
>
> These patches add new notifier function and implement it to panic_notifier_list.
> We used the hardcoded notifier chain so far, but it was not flexible. New
> notifier is very flexible, because user can change a list of order by debugfs.

How is the lack of flexibility a problem?
Specifics please.

My impression is that the purpose of this patchset is to build
infrastructure to sort out a conflict between kdb and the kexec code,
which it does not do, and it can not do if it does not own up to
it's real purpose.

If I am correct in understanding the purpose of this patchset it does
not even address the problem it is aimed at solving.

Eric
