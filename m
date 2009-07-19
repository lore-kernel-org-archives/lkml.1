Return-Path: <linux-kernel-owner+w=401wt.eu-S1751659AbZGSVgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbZGSVgl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 17:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbZGSVgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 17:36:39 -0400
Received: from smtp-out.google.com ([216.239.45.13]:25505 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbZGSVgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 17:36:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=LfWDp4Eq8rQbSQM4eOSNiGB9JZihbbiaZNbcPRbbNcwhh5HqjfwR0N3CuHa85gdv8
	u5y1UcfMuR53khkmWBL4g==
Date: Sun, 19 Jul 2009 14:36:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       Stephan von Krawcynski <skraw@ithnet.com>
Subject: Re: [Bug #13648] nfsd: page allocation failure
In-Reply-To: <bXZeuxPQAWE.A.BkG.-_oUKB@chimera>
Message-ID: <alpine.DEB.2.00.0907191433360.14636@chino.kir.corp.google.com>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera> <bXZeuxPQAWE.A.BkG.-_oUKB@chimera>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jul 2009, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13648
> Subject		: nfsd: page allocation failure
> Submitter	: Justin Piszcz <jpiszcz@lucidpixels.com>
> Date		: 2009-06-22 12:08 (15 days old)
> References	: http://lkml.org/lkml/2009/6/22/309
> 

Stephan von Krawczynski has this problem with e1000e (but not e1000 or 
tg3) at least as far back as 2.6.28, so this doesn't appear to be a 
regression introduced in 2.6.30.
