Return-Path: <linux-kernel-owner+w=401wt.eu-S932287AbZGOUXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287AbZGOUXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 16:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932275AbZGOUXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 16:23:00 -0400
Received: from smtp-out.google.com ([216.239.33.17]:23370 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274AbZGOUXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 16:23:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=n4JGSDU8IwjYFjecPmm+yBWh8STftgvdSdbgTN9VNc36/nHtXwXNzcksAlFbAiFwi
	Vud07KYyjTUinxk4yY8Pg==
Date: Wed, 15 Jul 2009 13:22:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Stephan von Krawczynski <skraw@ithnet.com>
cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: What to do with this message (2.6.30.1) ?
In-Reply-To: <20090715114605.42a354c0.skraw@ithnet.com>
Message-ID: <alpine.DEB.2.00.0907151321030.22582@chino.kir.corp.google.com>
References: <20090713134621.124aa18e.skraw@ithnet.com> <4807377b0907132240g6f74c9cbnf1302d354a0e0a72@mail.gmail.com> <alpine.DEB.2.00.0907132247001.8784@chino.kir.corp.google.com> <20090715084754.36ff73bf.skraw@ithnet.com> <alpine.DEB.2.00.0907150115190.14393@chino.kir.corp.google.com>
 <20090715114605.42a354c0.skraw@ithnet.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009, Stephan von Krawczynski wrote:

> Ok, so I just found out that slabtop -o outputs a lot of ANSI code by
> redirecting it, that output is merely unreadable. Can some kind soul please
> tell the author that formatting ANSI output in -o option makes no sense at
> all. top btw does not do this (top -b -n 1).
> I will produce your logs, but you will have a hard time reading that trash ...
> 

This is fixed in the latest release of procps[*], so maybe you could 
upgrade before generating the output?  If not, simply sending 
/proc/slabinfo would be better.

 [*] https://rhn.redhat.com/errata/RHBA-2009-0950.html
