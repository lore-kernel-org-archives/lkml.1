Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbZGFTMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbZGFTMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 15:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbZGFTL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 15:11:56 -0400
Received: from cinke.fazekas.hu ([195.199.244.225]:36472 "EHLO
	cinke.fazekas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbZGFTLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 15:11:55 -0400
Date: Mon, 6 Jul 2009 21:11:51 +0200 (CEST)
From: Marton Balint <cus@fazekas.hu>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: linux-kernel@vger.kernel.org
Subject: Re: vfat creates multiple files with the same filename
In-Reply-To: <87y6r9dz4h.fsf@devron.myhome.or.jp>
Message-ID: <Pine.LNX.4.64.0907062105470.31518@cinke.fazekas.hu>
References: <Pine.LNX.4.64.0906281935490.20945@cinke.fazekas.hu>
 <87tz1ylaq8.fsf@devron.myhome.or.jp> <Pine.LNX.4.64.0907010158560.835@cinke.fazekas.hu>
 <87y6r9dz4h.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009, OGAWA Hirofumi wrote:

> Marton Balint <cus@fazekas.hu> writes:
> 
> > On Tue, 30 Jun 2009, OGAWA Hirofumi wrote:
> >> Marton Balint <cus@fazekas.hu> writes:
> >> 
> >> > I don't know if removing the invalid characters silently instead of 
> >> > returning EINVAL is a good practice, but allowing two files with identical 
> >> > filenames is definitely wrong. 
> >> 
> >> The utf8 function seems didn't return the error for invalid char.
> >> 
> >> > Could someone please have a look at the problem? Unfortunately I am not 
> >> > qualified enough to track it down...
> >> >
> >> > I've run the testcase on both 2.6.30 and 2.6.31-rc1 kernels, but this bug 
> >> > is probably not very new, since I remember having it also in 2.6.27.
> >> 
> >> This is quick hack though, this should return -EINVAL for invalid char
> >> like nls.  Can you try this?
> >
> > It works for me, filenames with invalid utf-8 characters are now rejected, 
> > so I no longer can create multiple files with the same name. Thanks for 
> > the fix.
> 
> Thanks for testing.

Will the patch be included in 2.6.31?

Regards,
  Marton
