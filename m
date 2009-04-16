Return-Path: <linux-kernel-owner+w=401wt.eu-S1752496AbZDPEGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbZDPEGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 00:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750771AbZDPEGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 00:06:33 -0400
Received: from mail-qy0-f107.google.com ([209.85.221.107]:54956 "EHLO
	mail-qy0-f107.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbZDPEGc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 00:06:32 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Apr 2009 00:06:32 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GycrdJYpEEqIqyk4IX5clbP5aaQmd6a4ZQHX4Vvk7IqGs3x+xx6o98EjD8CG8BznY6
         Hu7Rsbg/eu9q2EkdsiPMPaDvBHNbtfxhIHxy9ZwOhKPq3UqE7pdzR/UuPmqVB6vgTHEp
         CzfW8glrK16K7nywhTu7qc+7yy/1AVARMM9Vk=
MIME-Version: 1.0
In-Reply-To: <20090416015955.GB7082@balbir.in.ibm.com>
References: <20090415120510.GX7082@balbir.in.ibm.com>
	 <20090416095303.b4106e9f.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090416015955.GB7082@balbir.in.ibm.com>
Date: Thu, 16 Apr 2009 09:29:53 +0530
Message-ID: <344eb09a0904152059w1a0ecfa4l6ff8c5f2130680ba@mail.gmail.com>
Subject: Re: [PATCH] Add file based RSS accounting for memory resource 
	controller (v2)
From: Bharata B Rao <bharata.rao@gmail.com>
To: balbir@linux.vnet.ibm.com
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 7:29 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
> Feature: Add file RSS tracking per memory cgroup
>
> From: Balbir Singh <balbir@linux.vnet.ibm.com>
>
> Changelog v3 -> v2
> 1. Add corresponding put_cpu() for every get_cpu()
>
> Changelog v2 -> v1
>
> 1. Rename file_rss to mapped_file
> 2. Add hooks into mem_cgroup_move_account for updating MAPPED_FILE statistics
> 3. Use a better name for the statistics routine.
>
>
> We currently don't track file RSS, the RSS we report is actually anon RSS.
> All the file mapped pages, come in through the page cache and get accounted
> there. This patch adds support for accounting file RSS pages. It should
>
> 1. Help improve the metrics reported by the memory resource controller
> 2. Will form the basis for a future shared memory accounting heuristic
>   that has been proposed by Kamezawa.
>
> Unfortunately, we cannot rename the existing "rss" keyword used in memory.stat
> to "anon_rss". We however, add "mapped_file" data and hope to educate the end
> user through documentation.
>
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Balbir, could you please also update the documentation with the
description about this new metric ?

Regards,
Bharata.
-- 
http://bharata.sulekha.com/blog/posts.htm
