Return-Path: <linux-kernel-owner+w=401wt.eu-S1763860AbYDVW32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763860AbYDVW32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759027AbYDVW3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:29:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759026AbYDVW3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:29:11 -0400
Message-ID: <480E6687.60804@redhat.com>
Date: Tue, 22 Apr 2008 17:28:23 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Eric Sandeen <sandeen@sandeen.net>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Joe Perches <joe@perches.com>
Subject: Re: [PATCH V2] use canary at end of stack to indicate overruns at
 oops time
References: <480D5F27.1030101@redhat.com>  <480E5ACF.7010105@sandeen.net> <1208902460.24124.17.camel@brick>
In-Reply-To: <1208902460.24124.17.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:

> Also, do you expect this to ever be used outside of sched.c?  Maybe just
> leave it as a static function there rather than an inline in the header.

the patch uses it in exit.c....

-Eric
