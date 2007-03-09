Return-Path: <linux-kernel-owner+w=401wt.eu-S1767597AbXCIX67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767597AbXCIX67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 18:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767602AbXCIX67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 18:58:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:47977 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767598AbXCIX66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 18:58:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b/KeZLG+CYuN+FgDHUkG4O5AwF6fuKN3f9fXvwto7rHeJRYJ2dLrE3ZOVzKG4XawBBeGq21jnCVX/dBvyae4zB02KWaO/CF+R5mWjSyd/n0SjKm8BwDtjMVDnULsyAd1u5dugoPq5MlUixoQtnuQfqzsRbAN9fY2XpFjK0+6vig=
Message-ID: <4ae3c140703091558p5e6625a9t3d2798fd67e7ac1a@mail.gmail.com>
Date: Fri, 9 Mar 2007 18:58:55 -0500
From: "Xin Zhao" <uszhaoxin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: question regarding the Linux block device cache
In-Reply-To: <4ae3c140703091424i25a0a3fcm6ba9d7bf348d04b6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4ae3c140703091424i25a0a3fcm6ba9d7bf348d04b6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I read the code and found that a block buffer is not necessarily freed
even if the corresponding inode is released. Looks like block buffer
can stay around as long as the system still has free memory. Is my
understanding correct?

-x

On 3/9/07, Xin Zhao <uszhaoxin@gmail.com> wrote:
> Hi,
>
> I am working on a file system that allow multiple files to share data
> blocks. That is, a data block can be shared by two or more files. Now
> my question is: suppose file A and B share the same data block D. Now
> a process open file A and read block D, then this process closes file
> A. If another process open file B and read block D right after the
> first process closes A, is the data of block D read from some cache or
> has to be loaded from disk again? I think this has to do with the
> Linux block device buffer cache. But I am not quite familiar with this
> part.
>
> Can someone help me or direct me to the right place to find the answer?
>
> Thanks in advance!
>
> -x
>
