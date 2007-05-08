Return-Path: <linux-kernel-owner+w=401wt.eu-S967329AbXEHLh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967329AbXEHLh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 07:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967111AbXEHLh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 07:37:26 -0400
Received: from terminus.zytor.com ([192.83.249.54]:33211 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966371AbXEHLhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 07:37:25 -0400
Message-ID: <464060EF.8090501@zytor.com>
Date: Tue, 08 May 2007 04:37:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Execute in place
References: <200705030211.36293.a1426z@gawab.com> <200705072356.51283.a1426z@gawab.com> <4640137A.8030000@zytor.com> <200705081436.11928.a1426z@gawab.com>
In-Reply-To: <200705081436.11928.a1426z@gawab.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> 
> You don't really think that anybody is suggesting to store the tmpfs data 
> without any coherency, do you?
> 
> I am suggesting that you can easily isolate tmpfs coherency from the rest of 
> the page-cache, by simply streaming tmpfs data out to an mmap and plugging 
> it with the tmpfs fat on umount.  And streaming things back in on mount.
> 

You still don't get it, do you?

tmpfs metadata doesn't live in the pagecache.

	-hpa
