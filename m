Return-Path: <linux-kernel-owner+w=401wt.eu-S964798AbXCKTQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964798AbXCKTQR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 15:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964805AbXCKTQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 15:16:17 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42833 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964798AbXCKTQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 15:16:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pavel Emelianov <xemul@sw.ru>
Cc: Andrew Morton <akpm@osdl.org>, Paul Menage <menage@google.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       containers@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 4/7] RSS accounting hooks over the code
References: <45ED7DEC.7010403@sw.ru> <45ED81F2.80402@sw.ru>
Date: Sun, 11 Mar 2007 13:14:55 -0600
In-Reply-To: <45ED81F2.80402@sw.ru> (Pavel Emelianov's message of "Tue, 06 Mar
	2007 18:00:02 +0300")
Message-ID: <m14porwq1c.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov <xemul@sw.ru> writes:

> Pages are charged to their first touchers which are
> determined using pages' mapcount manipulations in
> rmap calls.

NAK pages should be charged to every rss group whose mm_struct they
are mapped into.

Eric
