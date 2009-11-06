Return-Path: <linux-kernel-owner+w=401wt.eu-S1759484AbZKFRM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484AbZKFRM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 12:12:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759429AbZKFRM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 12:12:26 -0500
Received: from smtp.ultrahosting.com ([74.213.175.253]:42729 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758420AbZKFRM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 12:12:26 -0500
Date: Fri, 6 Nov 2009 12:10:45 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Minchan Kim <minchan.kim@gmail.com>
cc: npiggin@suse.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
Subject: Re: Subject: [RFC MM] mmap_sem scaling: Use mutex and percpu counter
  instead
In-Reply-To: <28c262360911060741x3f7ab0a2k15be645e287e05ac@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0911061209520.5187@V090114053VZO-1>
References: <alpine.DEB.1.10.0911051417370.24312@V090114053VZO-1>  <alpine.DEB.1.10.0911051419320.24312@V090114053VZO-1> <28c262360911060741x3f7ab0a2k15be645e287e05ac@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Nov 2009, Minchan Kim wrote:

> How about change from 'mm_readers' to 'is_readers' to improve your
> goal 'scalibility'?

Good idea. Thanks. Next rev will use your suggestion.

Any creative thoughts on what to do about the 1 millisecond wait period?

