Return-Path: <linux-kernel-owner+w=401wt.eu-S1760792AbZEZXZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760792AbZEZXZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760264AbZEZXZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:25:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760133AbZEZXZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:25:22 -0400
Date: Tue, 26 May 2009 16:24:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: adobriyan@gmail.com, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, torvalds@linux-foundation.org
Subject: Re: [PATCH 14/38] Remove struct mm_struct::exe_file et al
Message-Id: <20090526162415.fb9cefef.akpm@linux-foundation.org>
In-Reply-To: <20090526113618.GJ28083@us.ibm.com>
References: <20090526113618.GJ28083@us.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009 04:36:18 -0700
Matt Helsley <matthltc@us.ibm.com> wrote:

> I don't see any mention in the changelog of the point brought up by Ingo:
> 
> http://lkml.org/lkml/2009/4/10/105

Nor of Eric's comments.

Alexey, pleeeze don't do this.  We (read: I) heavily depend upon patch
submitters to keep track of outstanding issues and review comments,
etc.

If the patch submitter simply blows these things off then it devolves
to me having to keep track of each patch's issue list as well as the
patch itself.  My workload goes up by a factor of N and the error rate
goes up by N^2 :(

