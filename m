Return-Path: <linux-kernel-owner+w=401wt.eu-S1752100AbZKLMto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbZKLMto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 07:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbZKLMto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 07:49:44 -0500
Received: from adelie.canonical.com ([91.189.90.139]:40653 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbZKLMtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 07:49:43 -0500
Date: Thu, 12 Nov 2009 12:49:45 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Removing wrong judgement of checkpatch.pl for
 return as function
Message-ID: <20091112124945.GG9335@shadowen.org>
References: <20091103.104932.625281420231629894.mitake@dcl.info.waseda.ac.jp>
 <20091106222828.GC5191@penfold>
 <20091107.101429.21010532507617430.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091107.101429.21010532507617430.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 07, 2009 at 10:14:29AM +0900, Hitoshi Mitake wrote:

> Yes, I post the patch triggered the error I mentioned to lkml recently.
> I'm attaching the patch the tail of this mail.

> +		return (pthread_t)0;

Ahh, now I see how this could occur.  My test case has a variable where
this has a 0.  I think I've fixed this.  Could you test with the version
at the URL below (it may take a little time to replicate):

  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

Thanks.

-apw
