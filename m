Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbZFGQfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbZFGQfh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 12:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbZFGQf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 12:35:28 -0400
Received: from fmailhost03.isp.att.net ([204.127.217.103]:60231 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbZFGQf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 12:35:28 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A2BEC4F.6020908@lwfinger.net>
Date: Sun, 07 Jun 2009 11:35:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Rik van Riel <riel@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>	 <D9VoutSOyXP.A.hvH.Ha7KKB@chimera> <4A2BBC30.2030300@lwfinger.net>	 <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com>	 <4A2BCC6F.8090004@redhat.com> <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com>
In-Reply-To: <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Sun, Jun 7, 2009 at 5:19 PM, Rik van Riel <riel@redhat.com> wrote:
>> That is a very strange trace.  The Mem-Info indicates
>> that the system has more than enough memory free, and
>> also enough memory in higher-order free blocks.
>>
>> This would indicate a bug somewhere in the page
>> allocator - this memory should have been given to this
>> allocation request.
> 
> Aha, I always have difficulties deciphering the traces. But lets
> invite Mel to the party then!

I'm happy to see some action on this problem. As usual, I'm happy to
test patches and/or provide diagnostic output.

Larry
