Return-Path: <linux-kernel-owner+w=401wt.eu-S967418AbXEHL72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967418AbXEHL72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 07:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967415AbXEHL7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 07:59:24 -0400
Received: from [212.12.190.199] ([212.12.190.199]:33135 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S967397AbXEHL7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 07:59:22 -0400
From: Al Boldi <a1426z@gawab.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Execute in place
Date: Tue, 8 May 2007 15:02:11 +0300
User-Agent: KMail/1.5
Cc: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>,
       linux-kernel@vger.kernel.org
References: <200705030211.36293.a1426z@gawab.com> <200705081436.11928.a1426z@gawab.com> <464060EF.8090501@zytor.com>
In-Reply-To: <464060EF.8090501@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705081502.11210.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Al Boldi wrote:
> > You don't really think that anybody is suggesting to store the tmpfs
> > data without any coherency, do you?
> >
> > I am suggesting that you can easily isolate tmpfs coherency from the
> > rest of the page-cache, by simply streaming tmpfs data out to an mmap
> > and plugging it with the tmpfs fat on umount.  And streaming things back
> > in on mount.
>
> You still don't get it, do you?
>
> tmpfs metadata doesn't live in the pagecache.

It does not matter; you can deduce it on umount.


Thanks!

--
Al

