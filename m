Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbZJQUaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbZJQUaM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 16:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbZJQUaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 16:30:11 -0400
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:55932 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752005AbZJQUaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 16:30:10 -0400
From: Frans Pop <elendil@planet.nl>
To: Sven Geggus <lists@fuchsschwanzdomain.de>
Subject: Re: Kernel crash on 2.6.31.x (kcryptd: page allocation failure..)
Date: Sat, 17 Oct 2009 22:30:11 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       linux-mm@kvack.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <hbd4dk$5ac$1@ultimate100.geggus.net>
In-reply-To: <hbd4dk$5ac$1@ultimate100.geggus.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910172230.13162.elendil@planet.nl>
X-OriginalArrivalTime: 17 Oct 2009 20:30:13.0631 (UTC) FILETIME=[A16340F0:01CA4F68]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sven,

Sven Geggus wrote:
> I can reproducible crash my machine by writing bulk data from a
> socket to an encrypted partition. It always crashes after a few
> Gigabytes have been written.
> 
> The Partition in charge is using dm-crypt+xfs filesystem.

This is without any doubt related to an issue that's already being 
investigated. I have to warn you that the thread is very long:

http://thread.gmane.org/gmane.linux.kernel/896714

What is the _exact_ command sequence you use to reproduce it? I already 
have a testcase, but a second test case, or a simpler one, may be useful.

In all cases reported so far, and also in your case, networking is involved 
in the actual allocation errors.

It would also be useful if you could try to bisect the issue independently. 
For me bisection has proven difficult because the symptoms change 
between .30 and .31. The suspicion is that more than one change is 
involved in the regression.

Cheers,
FJP
