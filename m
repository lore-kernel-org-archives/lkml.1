Return-Path: <linux-kernel-owner+w=401wt.eu-S1761574AbZATOOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761574AbZATOOB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 09:14:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265AbZATOMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 09:12:44 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:49244 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760114AbZATOMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 09:12:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kICqVt+e2j1VrGGsg/do3T78mUbyKGhK4bBI0vVfKOpYblbFFSD5gGXBIckI55bq38
         gYK6pbvZTwsbBxH8dBlUe64pmCT/1/+XjbufwUQkPUr7GYt6EdENP6VHzAHZwmnXkHSR
         vT1mDtu7vxO6yqhkeHsCZgMcIouGc5AeCeaCw=
Message-ID: <4975DC24.5080806@gmail.com>
Date: Tue, 20 Jan 2009 15:13:56 +0100
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>,
       xfs mailing list <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
References: <497468C1.3000001@gmail.com> <4974CA20.6050308@sandeen.net> <20090120004611.GA6445@disturbed> <20090120112910.GA6831@infradead.org> <4975B9C4.7030401@gmail.com> <20090120114906.GA12526@infradead.org> <20090120121335.GA19182@infradead.org> <20090120124515.GA31838@infradead.org> <4975D88B.7020906@gmail.com> <20090120140514.GA2976@infradead.org>
In-Reply-To: <20090120140514.GA2976@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig pisze:
> On Tue, Jan 20, 2009 at 02:58:35PM +0100, Jacek Luczak wrote:
>> Good job! Is there some ,,quick'' fix?
> 
> The patch below makes it go away for me, alternatively just enable
> CONFIG_LBD.
> 
> 
> Index: linux-2.6/fs/xfs/xfs_types.h
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_types.h	2009-01-20 14:55:55.806068213 +0100
> +++ linux-2.6/fs/xfs/xfs_types.h	2009-01-20 14:56:01.437945154 +0100
> @@ -96,7 +96,7 @@ typedef	__uint64_t	xfs_dfilblks_t;	/* nu
>  /*
>   * Memory based types are conditional.
>   */
> -#if XFS_BIG_BLKNOS
> +#if 1 //XFS_BIG_BLKNOS
>  typedef	__uint64_t	xfs_fsblock_t;	/* blockno in filesystem (agno|agbno) */
>  typedef __uint64_t	xfs_rfsblock_t;	/* blockno in filesystem (raw) */
>  typedef __uint64_t	xfs_rtblock_t;	/* extent (block) in realtime area */
> 

Applied. Thanks. Will do some tests with your script.

-Jacek
