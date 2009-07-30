Return-Path: <linux-kernel-owner+w=401wt.eu-S1752334AbZG3T1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbZG3T1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 15:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbZG3T1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 15:27:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbZG3T1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 15:27:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/1] task_struct cleanup: move binfmt field to mm_struct
In-Reply-To: Oleg Nesterov's message of  Thursday, 30 July 2009 19:55:47 +0200 <20090730175547.GD3617@redhat.com>
References: <20090723161806.GA5690@redhat.com>
	<4A68FD3B.7040606@ct.jp.nec.com>
	<4A693569.1090009@ct.jp.nec.com>
	<20090724161449.GA3509@redhat.com>
	<4A6CF466.9040608@ct.jp.nec.com>
	<20090727165901.GA8854@redhat.com>
	<4A6E98DC.5020200@ct.jp.nec.com>
	<20090728143734.GA6664@redhat.com>
	<4A70EC76.6060109@ct.jp.nec.com>
	<4A70ECAD.203@ct.jp.nec.com>
	<20090730175547.GD3617@redhat.com>
X-Windows: a mistake carried out to perfection.
Message-Id: <20090730192700.D1F784C7A4@magilla.sf.frob.com>
Date: Thu, 30 Jul 2009 12:27:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 07/30, Hiroshi Shimamoto wrote:
> >
> > Because the binfmt is not different between threads in the same process,
> > it can be moved from task_struct to mm_struct. And binfmt moudle is handled
> > per mm_struct instead of task_struct.
> 
> Looks like a nice patch to me.

I agree!  It's a good clean-up to move this field.


Thanks,
Roland
