Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbZHTWfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbZHTWfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 18:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbZHTWfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 18:35:11 -0400
Received: from vena.lwn.net ([206.168.112.25]:37733 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053AbZHTWfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 18:35:11 -0400
Date: Thu, 20 Aug 2009 16:35:10 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <menage@google.com>, bblum@andrew.cmu.edu, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       Dave Hansen <haveblue@us.ibm.com>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 4/8] Use vmalloc for large cgroups pidlist allocations
Message-ID: <20090820163510.27942b62@bike.lwn.net>
In-Reply-To: <20090820141400.f6d3d5a6.akpm@linux-foundation.org>
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com>
	<20090818235827.22531.60306.stgit@menage.mtv.corp.google.com>
	<20090820141400.f6d3d5a6.akpm@linux-foundation.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Aug 2009 14:14:00 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> Hang on.  Isn't this why Dave just wrote and I just rush-merged
> lib/flex_array.c?
> 
> Was that code evaluated for this application and judged unsuitable?  If so,
> for what reason?

Should it be helpful: I wrote an overview of the flex_array API here:

	http://lwn.net/Articles/345273/

I could format it up for addition to Documentation/ if people want.

jon
