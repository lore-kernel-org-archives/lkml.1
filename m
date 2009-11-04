Return-Path: <linux-kernel-owner+w=401wt.eu-S933100AbZKDXUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100AbZKDXUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 18:20:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932948AbZKDXUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 18:20:22 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41141 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932750AbZKDXUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 18:20:22 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: cc1plus invoked oom-killer: gfp_mask=0x280da, order=0, oom_adj=0
Cc: kosaki.motohiro@jp.fujitsu.com, Justin Mattock <justinmattock@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gcc@gcc.gnu.org, David Rientjes <rientjes@cs.washington.edu>
In-Reply-To: <20091104072826.8b2dfb73.akpm@linux-foundation.org>
References: <20091104182238.54CB.A69D9226@jp.fujitsu.com> <20091104072826.8b2dfb73.akpm@linux-foundation.org>
Message-Id: <20091105080656.54CE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  5 Nov 2009 08:20:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	if (verbose) {
> > +		task_lock(p);
> 
> We need to be careful with which locks we take on the oom-killer path,
> because it can be called by code which already holds locks.  But I
> expect task_lock() will be OK.

Sure.
task_lock() is already used various oom path. I think this is ok.



