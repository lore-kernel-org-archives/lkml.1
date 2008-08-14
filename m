Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbYHNK0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbYHNK0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 06:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYHNK0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 06:26:41 -0400
Received: from smtp01.mtn.co.za ([196.13.230.214]:1838 "EHLO smtp01.mtn.co.za"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbYHNK0l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 06:26:41 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: POSIX_FADV_DONTNEED
Date: Thu, 14 Aug 2008 12:26:28 +0200
Message-ID: <70D00C33FCD1FD4A860DEAC228277C0C048425EA@MTNMAIL1.mtn.co.za>
In-Reply-To: <20080814021703.355b2a76.akpm@linux-foundation.org>
Thread-Topic: POSIX_FADV_DONTNEED
thread-index: Acj97pckDKOf6RtBT2SgyuDTj/x30AACKJTg
References: <70D00C33FCD1FD4A860DEAC228277C0C048425D1@MTNMAIL1.mtn.co.za> <20080814021703.355b2a76.akpm@linux-foundation.org>
From: "Trevor Woollacott [ MTN - Innovation Centre ]" <Woolla_T@mtn.co.za>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 14 Aug 2008 10:29:34.0340 (UTC) FILETIME=[A5151C40:01C8FDF8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks for the response Andrew. Is there a way to check when the cached
data has been freed after fadvise has been called?

-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org] 
Sent: Thursday, 14 August 2008 11:17 AM
To: Trevor Woollacott [ MTN - Innovation Centre ]
Cc: linux-kernel@vger.kernel.org
Subject: Re: POSIX_FADV_DONTNEED

On Fri, 1 Aug 2008 17:05:39 +0200 "Trevor Woollacott [ MTN - Innovation
Centre ]" <Woolla_T@mtn.co.za> wrote:

> 
> Hi all
> 
> Does anyone know if posix_fadvise() with POSIX_FADV_DONTNEED is
> blocking/unblocking?

It tries to be nonblocking and will mostly succeed in that.  It might
occasionally block on a metadata read or journal congestion or
something, so it isn't guaranteed.


NOTE: This e-mail message is subject to the MTN Group disclaimer see http://www.mtn.co.za/default.aspx?pid=34411 
