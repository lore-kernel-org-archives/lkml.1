Return-Path: <linux-kernel-owner+w=401wt.eu-S1030190AbXCDCgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030190AbXCDCgB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 21:36:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932774AbXCDCgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 21:36:01 -0500
Received: from wr-out-0506.google.com ([64.233.184.228]:5591 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932745AbXCDCgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 21:36:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VIBs2+t28eCl6xBF63gGlRi1efgdxk+qVTZdybXcoleQP8XBezw8KJ3v8r0SnxiF49JE+eYkYFdAdGL07dRUmnJXGXm37iap59awDtwz8f7nbnYEyASaAT1nxuWYX0A/8JP33uhb3VnUg5fg7fWVh11rBMrcs8v3e3R/6KH66v0=
Message-ID: <75b66ecd0703031835j5ff2846fpd4761a89f67fc2f1@mail.gmail.com>
Date: Sat, 3 Mar 2007 21:35:59 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: userspace pagecache management tool
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070303173933.9f46459c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>
	 <75b66ecd0703031716k5b9fd96br9ecd93f1fc3a6032@mail.gmail.com>
	 <20070303173933.9f46459c.akpm@linux-foundation.org>
X-Google-Sender-Auth: 4dfd9140401792bd
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/3/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> But yes, updatedb's pagecache usage will be mainly metadata, and this tool
> doesn't address metadata pagecache, although it could do so.
>

With no kernel changes?  How?  I can't find an equivalent API to
posix_fadvise() for metadata.

Lee
