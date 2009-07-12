Return-Path: <linux-kernel-owner+w=401wt.eu-S1752051AbZGLFjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbZGLFjU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 01:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbZGLFjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 01:39:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:50346 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbZGLFjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 01:39:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eajfUuAYsHmtyOh8gmP3bGNQKUSrGwhBV/wlbAda8ZBnM96ATUq2qWBJQMCzBofq9s
         5yfqD4W5k+0/c68OpRIJSH8WzD5aTL8yhIaLJe1sURMr1iBrcf8T9q1/lUGHqTFOHqy+
         2tHpYrDCrZPrZIW1SB2Kyyg+gIrBgzrFKKue0=
Date: Sun, 12 Jul 2009 09:39:07 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [rfc -tip] lib,rb-tree - introduce rb_for_each helper
Message-ID: <20090712053907.GA4782@lenovo>
References: <20090711220009.GA16028@lenovo> <20090711222928.GD6641@nowhere> <20090711223232.GE6641@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090711223232.GE6641@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Frederic Weisbecker - Sun, Jul 12, 2009 at 12:32:33AM +0200]
| On Sun, Jul 12, 2009 at 12:29:30AM +0200, Frederic Weisbecker wrote:
| > 	     pos = rb_next(pos->memb, typeof(*pos), memb))
| 
| pos = rb_next(pos) would suffice :)
| 

Hi Frederic,

mind to pick the patch up and complete it with
rb_for_each_entry as well? ;)

	-- Cyrill
