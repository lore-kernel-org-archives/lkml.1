Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbZIYDNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbZIYDNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 23:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbZIYDND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 23:13:03 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:43082 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbZIYDND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 23:13:03 -0400
Date: Fri, 25 Sep 2009 12:12:34 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] nommu: Correct is_vmamloc_or_module_addr() definition.
Message-ID: <20090925031234.GF12099@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20090925030706.GE12099@linux-sh.org> <20090925120830.c010bc71.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090925120830.c010bc71.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 12:08:30PM +0900, KAMEZAWA Hiroyuki wrote:
> On Fri, 25 Sep 2009 12:07:06 +0900
> Paul Mundt <lethal@linux-sh.org> wrote:
> 
> > Commit 81ac3ad9061dd9cd490ee92f0c5316a14d77ce18 broke the nommu build
> > due to is_vmalloc_or_module_addr() not being marked inline. Fix it up.
> > 
> > Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> Ah, sorry. I think Andrew queues the same patch.
> 
Ah, I'm too slow, David already caught it:

commit 934831d060ccd5471ecbc562804a8d3ccd6e562c
Author: David Howells <dhowells@redhat.com>
Date:   Thu Sep 24 12:33:32 2009 +0100

    NOMMU: Fallback for is_vmalloc_or_module_addr() should be inline

    The NOMMU fallback for is_vmalloc_or_module_addr() should be static inline,
    not just static, in linux/mm.h.

    Signed-off-by: David Howells <dhowells@redhat.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Sorry for the noise!
