Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbXCMRcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbXCMRcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 13:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbXCMRcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 13:32:25 -0400
Received: from gw.goop.org ([64.81.55.164]:41590 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbXCMRcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 13:32:24 -0400
Message-ID: <45F6E027.2060800@goop.org>
Date: Tue, 13 Mar 2007 10:32:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@suse.de>, zach@vmware.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] Fix vmi time header bug
References: <45F5DB00.1070506@vmware.com>	<20070312223136.dc6969f3.akpm@linux-foundation.org>	<45F648B1.5000408@vmware.com>	<200703131345.06514.ak@suse.de> <20070313055944.bf89eb9b.akpm@linux-foundation.org>
In-Reply-To: <20070313055944.bf89eb9b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Correctly matching the section annotation on declarations and definitions
> is needed by at least ARM.  We should ensure that we do this on all future
> patches and we should also apply this patch if only for this reason.
>
> (The ARM thing is a pain, because the compiler cannot check that the
> definition and declaration match.  However something like sparse could do
> so).
>   

It's also useful documentation.  Knowing whether a function is __init is
an important part of its interface.

    J
