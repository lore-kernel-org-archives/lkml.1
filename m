Return-Path: <linux-kernel-owner+w=401wt.eu-S1764497AbYEIAFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764497AbYEIAFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 20:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYEIAE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 20:04:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53179 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbYEIAE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 20:04:57 -0400
Date: Fri, 09 May 2008 09:04:27 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] call_usermodehelper_setup() should use GFP_KERNEL
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <4823928D.7080907@goop.org>
References: <20080509084248.43B5.KOSAKI.MOTOHIRO@jp.fujitsu.com> <4823928D.7080907@goop.org>
Message-Id: <20080509085731.43BD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> KOSAKI Motohiro wrote:
> > UMH_WAIT_EXEC and UMH_WAIT_PROC mean wait on finish of exec or process exit.
> > I can't imagine situation that exec is waitable *and* allocate isn't waitable.
> 
> Yeah, that's why I was asking about UMH_NO_WAIT, where the caller may 
> not want to wait, but the context would allow the allocation to block if 
> necessary.

sorry, I misunderstood ;)

Yeah, you are right.
but it is no regression.
I agree with my plan have improve chance, but it is better than current.



