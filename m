Return-Path: <linux-kernel-owner+w=401wt.eu-S932693AbXIMVd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693AbXIMVd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 17:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757797AbXIMVdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 17:33:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51122 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754779AbXIMVdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 17:33:49 -0400
Date: Thu, 13 Sep 2007 14:33:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
cc: viro@ftp.linux.org.uk, hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Credentials test patch
In-Reply-To: <1839.1189718341@redhat.com>
Message-ID: <alpine.LFD.0.999.0709131431060.16478@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0709131304510.16478@woody.linux-foundation.org>
 <1577.1189713412@redhat.com> <1839.1189718341@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 Sep 2007, David Howells wrote:
> 
> > Why is it trying to make it look like a variable?
> 
> Like 'current' for instance?

"current" has solid *historical* reasons for being that way.

Namely: it actually *was* a variable. That worked fine for UP. It got 
changed much much later.

Also, even in modern times, "current" is optimized to hell and back, and 
is often as cheap (or cheaper than) a global variable, so there is also no 
subtle performance question.

So using "current" as an excuse is not really valid. AT ALL.

		Linus
