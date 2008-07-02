Return-Path: <linux-kernel-owner+w=401wt.eu-S1762032AbYGBE4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762032AbYGBE4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 00:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbYGBE4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 00:56:33 -0400
Received: from mail.suse.de ([195.135.220.2]:38688 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbYGBE4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 00:56:32 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] aio: aio_complete() will never be called in interrupt context
Date: Wed, 2 Jul 2008 10:30:42 +0530
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
       Benjamin LaHaise <bcrl@kvack.org>, Jeff Moyer <jmoyer@redhat.com>
References: <200806260930.59836.knikanth@suse.de> <200807011359.57164.knikanth@suse.de> <486A8A92.6050200@oracle.com>
In-Reply-To: <486A8A92.6050200@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807021030.43009.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 July 2008 01:20:42 Zach Brown wrote:
> > I did not do any specific testing. Just ran multiple instances of a
> > file-copy utility that uses aio and a bit of Chris Mason's aio-stress.
>
> Are you running these tests under a kernel with lockdep enabled?
>

Yes. I have CONFIG_LOCKDEP_SUPPORT=y and did not get any warning messages.

> > p.s: Is the archives of the linux-aio list available somewhere? The URL
> > in the mail footer seems to be unavailable.
>
> The very first google hit for 'linux-aio mailing list archive' works:
>
>   http://marc.info/?l=linux-aio
>

Thanks and sorry for the noise.

But it would be nice if the link in the mail footer(www.kvack.org/aio) is 
changed to an active link or removed. The link redirects to 
www.kvack.org/~blah/aio/ which returns 404

Thanks
Nikanth Karthikesan
