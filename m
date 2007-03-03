Return-Path: <linux-kernel-owner+w=401wt.eu-S933127AbXCCWZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127AbXCCWZo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 17:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933134AbXCCWZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 17:25:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933127AbXCCWZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 17:25:43 -0500
Message-ID: <45E9F5DA.2070708@redhat.com>
Date: Sat, 03 Mar 2007 17:25:30 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>	<45E9DD4A.2060806@redhat.com>	<20070303131204.6706a95c.akpm@linux-foundation.org>	<45E9E910.2070804@redhat.com> <20070303140744.b22699dd.akpm@linux-foundation.org>
In-Reply-To: <20070303140744.b22699dd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> Well, backup programs are a unique case.  Let's say instead that the user
> has just generated a 600MB ISO image.
> 
> The kernel *just doesn't know* whether the user will next try to read the
> kernel tree or will next try to read that ISO image.
> 
> That, Rik, is my point, and is the entire point of this work.

I still don't understand why "the backup program flushed my data out
of the cache with POSIX_FADV_DONTNEED" is an improvement over "the
backup program flushed my data out of the cache by reading other files".

Your code may be useful for a few specialized situations, but I don't
see it actually fixing most of the examples you gave in your
announcement, except for the DVD copying one.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
