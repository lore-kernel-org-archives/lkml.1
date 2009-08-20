Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbZHTVT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbZHTVT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbZHTVT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:19:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752204AbZHTVTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:19:55 -0400
Date: Thu, 20 Aug 2009 14:14:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Menage <menage@google.com>
Cc: bblum@andrew.cmu.edu, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       Dave Hansen <haveblue@us.ibm.com>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 4/8] Use vmalloc for large cgroups pidlist allocations
Message-Id: <20090820141400.f6d3d5a6.akpm@linux-foundation.org>
In-Reply-To: <20090818235827.22531.60306.stgit@menage.mtv.corp.google.com>
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com>
	<20090818235827.22531.60306.stgit@menage.mtv.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Aug 2009 16:58:27 -0700
Paul Menage <menage@google.com> wrote:

> From: Ben Blum <bblum@google.com>
> 
> 
> Use vmalloc for large cgroups pidlist allocations
> 
> Separates all pidlist allocation requests to a separate function that judges
> based on the requested size whether or not the array needs to be vmalloced or
> can be gotten via kmalloc, and similar for kfree/vfree.
> 

Hang on.  Isn't this why Dave just wrote and I just rush-merged
lib/flex_array.c?

Was that code evaluated for this application and judged unsuitable?  If so,
for what reason?

If not, can someone please do this?

Ta.


