Return-Path: <linux-kernel-owner+w=401wt.eu-S1756464AbXJHRyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbXJHRyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 13:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbXJHRyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 13:54:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbXJHRyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 13:54:02 -0400
Message-ID: <470A6EA5.20704@redhat.com>
Date: Mon, 08 Oct 2007 13:53:41 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.23-rc9-git5: Known regressions from 2.6.22
References: <200710072202.34621.rjw@sisk.pl>
In-Reply-To: <200710072202.34621.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2007 04:02 PM, Rafael J. Wysocki wrote:
> This message contains a list of some known regressions from 2.6.22 for which
> there are no fixes in the mainline that I know of.  If any of them have been fixed
> already, please let me know.
> 
> If you know of any other unresolved regressions from 2.6.22, please let me know
> either and I'll add them to the list.
> 

"top displaying 9999% CPU usage"

Report:
http://lkml.org/lkml/2007/10/3/123

Fix, reverting to imprecise time accounting:
http://lkml.org/lkml/2007/10/4/389
