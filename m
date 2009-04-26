Return-Path: <linux-kernel-owner+w=401wt.eu-S1756700AbZDZUTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbZDZUTr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 16:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbZDZUTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 16:19:37 -0400
Received: from smtp-out.google.com ([216.239.45.13]:10674 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425AbZDZUTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 16:19:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=M1wNnJ9poH8OtVL1QbqVDOW+K2iRAzMG+1bzrWOC16D7qqxmlQFfZysq49kxrpak5
	F/t/KKHv/o7FWUxRwqQ3g==
Date: Sun, 26 Apr 2009 13:19:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Bart <mmx@riz.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13112] Oops in drain_array
In-Reply-To: <egHshlwQQFE.A.KjC.JpE9JB@chimera>
Message-ID: <alpine.DEB.2.00.0904261314430.18988@chino.kir.corp.google.com>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera> <egHshlwQQFE.A.KjC.JpE9JB@chimera>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Apr 2009, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.28 and 2.6.29.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13112
> Subject		: Oops in drain_array
> Submitter	: Bart <mmx@riz.pl>
> Date		: 2009-04-14 10:21 (13 days old)
> References	: http://marc.info/?l=linux-kernel&m=123970493224628&w=4
> 

Bart, is it possible to try with CONFIG_DEBUG_SLAB enabled?
