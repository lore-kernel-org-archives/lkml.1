Return-Path: <linux-kernel-owner+w=401wt.eu-S1760968AbXKMFZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760968AbXKMFZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 00:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760898AbXKMFZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 00:25:41 -0500
Received: from smtp-out.google.com ([216.239.33.17]:7135 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760899AbXKMFZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 00:25:40 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:mime-version:
	content-type:content-transfer-encoding:content-disposition;
	b=L+YEWXNqXVrmqgwsZBnvaflDA75sOh1cC9Ew/oj042aYIoMaZx5aF+QCRhnH8cI5z
	0ZE7zFjqQAkKFzM6zXlGg==
Message-ID: <6599ad830711122125u576e85a6w428466a0ab46dbc6@mail.gmail.com>
Date: Mon, 12 Nov 2007 21:25:32 -0800
From: "Paul Menage" <menage@google.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Revert for cgroups CPU accounting subsystem patch
Cc: LKML <linux-kernel@vger.kernel.org>, containers@lists.linux-foundation.org,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>,
       "Ingo Molnar" <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please can you revert commit 62d0df64065e7c135d0002f069444fbdfc64768f,
entitled "Task Control Groups: example CPU accounting subsystem" ?

This was originally intended as a simple initial example of how to
create a control groups subsystem; it wasn't intended for mainline,
but I didn't make this clear enough to Andrew.

The CFS cgroup subsystem now has better functionality for the
per-cgroup usage accounting (based directly on CFS stats) than the
"usage" status file in this patch, and the "load" status file is
rather simplistic - although having a per-cgroup load average report
would be a useful feature, I don't believe this patch actually
provides it. If it gets into the final 2.6.24 we'd probably have to
support this interface for ever.

Thanks,

Paul
