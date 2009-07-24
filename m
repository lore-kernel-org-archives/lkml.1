Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbZGXXig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbZGXXig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 19:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbZGXXif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 19:38:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755219AbZGXXid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 19:38:33 -0400
Date: Fri, 24 Jul 2009 16:38:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       menage@google.com, vda.linux@googlemail.com, mikew@google.com,
       lizf@cn.fujitsu.com, xiyou.wangcong@gmail.com,
       kamezawa.hiroyu@jp.fujitsu.com, hpa@zytor.com, bblum@google.com,
       dave@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH] flexible array implementation v4
Message-Id: <20090724163814.08c7eee3.akpm@linux-foundation.org>
In-Reply-To: <20090723152647.D9391722@kernel>
References: <20090723152647.D9391722@kernel>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009 08:26:47 -0700
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

>  linux-2.6.git-dave/include/linux/flex_array.h |   46 ++++
>  linux-2.6.git-dave/lib/Makefile               |    2 
>  linux-2.6.git-dave/lib/flex_array.c           |  269 ++++++++++++++++++++++++++

I haven't looked at this lately but I merged it.

As it's obviously non-injurious, we could slip it into 2.6.31 for
convenience's sake but without any callers that's just runtime bloat. 
So I guess we wait for some additional callers to come along and prove
its worth.

>  linux-2.6.git-dave/lib/go.sh                  |   17 +

I dropped that bit.
