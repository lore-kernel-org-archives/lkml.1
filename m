Return-Path: <linux-kernel-owner+w=401wt.eu-S1754382AbXHOFeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbXHOFeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 01:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbXHOFeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 01:34:04 -0400
Received: from mail.gmx.net ([213.165.64.20]:60898 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751317AbXHOFeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 01:34:03 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18zh31rEk4zgzIcuihawRmpLCTRE7Y+x2wE31Saaa
	5dbgsWc3BtWkCn
Subject: Re: QUESTION: RT & SCHED & fork: ?MISSING EQUIV of task_new_fair
	for RT tasks.
From: Mike Galbraith <efault@gmx.de>
To: Mitchell Erblich <erblichs@earthlink.net>
Cc: "\"Linux Kernel Mailing List\"" <linux-kernel@vger.kernel.org>,
       "\"Ingo Molnar\"" <mingo@elte.hu>,
       "\"\\\"Dmitry Adamushko\\\"\"" <dmitry.adamushko@gmail.com>
In-Reply-To: <000501c7dea9$3bfca1c0$6501a8c0@earthlink.net>
References: <000501c7dea9$3bfca1c0$6501a8c0@earthlink.net>
Content-Type: text/plain
Date: Wed, 15 Aug 2007 07:33:57 +0200
Message-Id: <1187156037.6615.17.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 12:28 -0700, Mitchell Erblich wrote:
> Group, Ingo Molnar, etc,
> 
> Why does the rt sched_class contain fewer elements than fair?
> missing is the RT for .task_new.

No class specific initialization needs to be done for RT tasks.

	-Mike

