Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbZDJEOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbZDJEOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 00:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZDJEOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 00:14:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49494 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZDJEOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 00:14:04 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 1/1] Document get_user_pages_fast()
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Andy Grover <andy.grover@oracle.com>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, npiggin@suse.de
In-Reply-To: <20090410121923.7939.A69D9226@jp.fujitsu.com>
References: <20090409201309.db1c2c52.akpm@linux-foundation.org> <20090410121923.7939.A69D9226@jp.fujitsu.com>
Message-Id: <20090410131200.793C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 10 Apr 2009 13:13:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > and Cow change owner process.
> > 
> > hm.  buggy userspace? Why is that a problem from a kernel perspective?
> 
> We already started to discuttion in "[PATCH] fork vs gup(-fast) fix" thread.
> but this is very difficult problem. it is still in progress ;)

note:
access_process_vm() tell us right get_user_pages() usage.
mmap_sem prevent fork in critical section. then it don't have cow risk.



> > > Yes, current all gup caller have serious bug. especially direct-io, aio, bio
> > > are broken.



