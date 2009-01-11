Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZAKSGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZAKSGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 13:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbZAKSGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 13:06:10 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:30645 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbZAKSGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 13:06:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SRLdeblBWsiTOoOQn2/Q6WAbBY5LBoHf5GlLuIUqXqICiDibHs5ZNdPq1H41Jl5WuX
         QeNmZpaFzpZcqA2KWkwDsyh4jEfdXhY6AwAVYAoAorqYniodi5dQYzsElv/VIE2pAKqj
         nlJA2iMCv+4qrFgZC0k6ZN06QAfv5Mwj5r7FY=
Message-ID: <21d34cad0901111006j68d92314t60f910cd400d4474@mail.gmail.com>
Date: Mon, 12 Jan 2009 02:06:07 +0800
From: "Qinghuang Feng" <qhfeng.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] btrfs & squashfs: Move btrfs and squashfsto's magic number to <linux/magic.h>
Cc: "Phillip Lougher" <phillip@lougher.demon.co.uk>,
       "Chris Mason" <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <496a31c9.04506e0a.03e0.0963@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <496a31c9.04506e0a.03e0.0963@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 1:52 AM, Qinghuang Feng <qhfeng.kernel@gmail.com> wrote:
> Use the standard magic.h for btrfs and squashfs.
>
The patch can't be split to two pieces, otherwise it will conflict
because magic.h would be
modified twice.
So I also send it to akpm, he must have a good idea.
