Return-Path: <linux-kernel-owner+w=401wt.eu-S1757040AbYHOIdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040AbYHOIdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 04:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbYHOIdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 04:33:47 -0400
Received: from smtp02.mtn.co.za ([196.11.240.34]:3906 "EHLO smtp02.mtn.co.za"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071AbYHOIdr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 04:33:47 -0400
X-Greylist: delayed 617 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Aug 2008 04:33:46 EDT
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: POSIX_FADV_DONTNEED
Date: Fri, 15 Aug 2008 10:23:15 +0200
Message-ID: <70D00C33FCD1FD4A860DEAC228277C0C048425ED@MTNMAIL1.mtn.co.za>
In-Reply-To: <20080814091521.e4d9be53.akpm@linux-foundation.org>
Thread-Topic: POSIX_FADV_DONTNEED
thread-index: Acj+KQkQ2wOH282MRleeuO5ISrqangAhsEmA
References: <70D00C33FCD1FD4A860DEAC228277C0C048425D1@MTNMAIL1.mtn.co.za><20080814021703.355b2a76.akpm@linux-foundation.org><70D00C33FCD1FD4A860DEAC228277C0C048425EA@MTNMAIL1.mtn.co.za> <20080814091521.e4d9be53.akpm@linux-foundation.org>
From: "Trevor Woollacott [ MTN - Innovation Centre ]" <Woolla_T@mtn.co.za>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 15 Aug 2008 08:23:25.0686 (UTC) FILETIME=[3039E960:01C8FEB0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Thu, 14 Aug 2008 12:26:28 +0200 "Trevor Woollacott [ MTN -
Innovation Centre ]" <Woolla_T@mtn.co.za> wrote:
>
> > 
> > > On Fri, 1 Aug 2008 17:05:39 +0200 "Trevor Woollacott [ MTN - 
> > > Innovation Centre ]" <Woolla_T@mtn.co.za> wrote:
> 
> (please don't top-post).
> 
> > > > 
> > > > Hi all
> > > > 
> > > > Does anyone know if posix_fadvise() with POSIX_FADV_DONTNEED is 
> > > > blocking/unblocking?
> > > 
> > > It tries to be nonblocking and will mostly succeed in that.  It 
> > > might occasionally block on a metadata read or journal congestion 
> > > or something, so it isn't guaranteed.
> > >
> >
> > Thanks for the response Andrew. Is there a way to check when the 
> > cached data has been freed after fadvise has been called?
> > 
>
> I assume you meant "whether", not "when".
>
> Not directly.  I believe that the best way of obtaining that 
> information remains mmap()ing the file then querying the presence of 
> pages via mincore().

Thanks for the advice

NOTE: This e-mail message is subject to the MTN Group disclaimer see http://www.mtn.co.za/default.aspx?pid=34411 
