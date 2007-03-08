Return-Path: <linux-kernel-owner+w=401wt.eu-S933194AbXCHTkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194AbXCHTkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 14:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933200AbXCHTkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 14:40:13 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:43870 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194AbXCHTkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 14:40:11 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 8 Mar 2007 11:40:10 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Avi Kivity <avi@argo.co.il>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "David M. Lloyd" <dmlloyd@flurg.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/5] signalfd v2 - signalfd core ...
In-Reply-To: <45F06528.7040506@argo.co.il>
Message-ID: <Pine.LNX.4.64.0703081138120.7515@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703071712210.3672@alien.or.mcafeemobile.com>
 <1173364264.6891.3.camel@localhost> <Pine.LNX.4.64.0703080742220.7015@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703080812290.10832@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703080825420.7015@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703080852170.10832@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703081113060.7515@alien.or.mcafeemobile.com>
 <45F06528.7040506@argo.co.il>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2007, Avi Kivity wrote:

> Davide Libenzi wrote:
> > So, to cut it short, I can do the pseudo-siginfo read(2), but I don't like
> > it too much (little, actually). The siginfo, as bad as it is, is a standard
> > used in many POSIX APIs (hence even in kernel), and IMO if we want to send
> > that back, a struct siginfo should be.
> >   
> 
> You can send the data in the 32/64 neutral format, and have glibc convert it
> to a siginfo, and everybody's happy.

Except Uli :)
The problem with the siginfo is that it is a brain-dead structure with 
unions and data dependent on types (and pointers). Pretty fugly.



- Davide


