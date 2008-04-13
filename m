Return-Path: <linux-kernel-owner+w=401wt.eu-S1758623AbYDMQW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623AbYDMQW5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 12:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbYDMQWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 12:22:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:19262 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbYDMQWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 12:22:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=jRJ/tmTMAz9iOKY4tzuk58G6e+IajaotEBCCs7tUtcdbz8HwV+W1NUqaPgarJ3l3B4SfGlbxBj3O2vLwsL94dENw2CRn6qSn38VV5LngWaqpom1odOd82+WJhZusD0YF0xYEuPw0WA2RLaodSP2MQGZTR7CdY0GbvCT/KBnSqBM=
Date: Sun, 13 Apr 2008 20:18:12 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: static char *buf; (was Re: +
	v4l-fix-concurrent-read-from-proc-videocodecs.patch added to -mm
	tree)
Message-ID: <20080413161812.GA21575@martell.zuzino.mipt.ru>
References: <200804130902.m3D92W4u012757@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804130902.m3D92W4u012757@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -static char *videocodec_buf = NULL;
> -static int videocodec_bufsize;

> -	kfree(videocodec_buf);
> -	videocodec_buf = kmalloc(size, GFP_KERNEL);

Speaking of this failure mode... cfi_staa_writev() does the same trick
allocating and freeing global pointer to data.
Is this a bug too?

