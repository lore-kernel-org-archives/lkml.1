Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbXEDAqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbXEDAqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 20:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbXEDAqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 20:46:39 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37552 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754317AbXEDAqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 20:46:38 -0400
Date: Fri, 4 May 2007 02:46:36 +0200
From: Adrian Bunk <bunk@stusta.de>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [patch] compiler: introduce __used and __maybe_unused
Message-ID: <20070504004636.GU3531@stusta.de>
References: <Pine.LNX.4.64.0705031734520.21416@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705031734520.21416@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 05:35:57PM -0700, David Rientjes wrote:
>...
> There was a mistake in the current implementation of __attribute_used__
> whereas it would be defined to be __attribute__((used)) incorrectly for
> gcc 3.3 and later.  The unit-at-a-time compilation scheme was only
> introduced in gcc 3.4 and later versions as specified in 
> http://www.gnu.org/software/gcc/gcc-3.4/changes.html.
>...

AFAIR, Suse shipped a release of their distribution with a gcc 3.3 
containing a backported unit-at-a-time.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

