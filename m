Return-Path: <linux-kernel-owner+w=401wt.eu-S1759195AbXHUGlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195AbXHUGlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033AbXHUGlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:41:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:3307 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbXHUGlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:41:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z2TRcSr1WgoLlv4WjlsN/Ic3BRe/B5KZX3Hd1yu+smc86dZ5gqM1+dUOCutklI0mT0QVFNn1HnOsEN3CBrhBsxVyXEnTOwAF/16YN8ERl98J3liFYz8Onk9AwxE6Lge9Ygh0cASmEc8Yan8OxQfB9SUvVZHpHovS3myX1JzXM/g=
Message-ID: <4ae3c140708202341x13c8accfq5ad6f747c216dffe@mail.gmail.com>
Date: Tue, 21 Aug 2007 02:41:07 -0400
From: "Xin Zhao" <uszhaoxin@gmail.com>
To: "Kevin Hao" <haokexin@gmail.com>
Subject: Re: How Linux /proc filesystem convert a fd to the actual pathname?
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <8dd980de0708202303l2d3be5bj6682a98df4a40d99@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4ae3c140708201958x3c88b317o2ba9be64177978f5@mail.gmail.com>
	 <8dd980de0708202303l2d3be5bj6682a98df4a40d99@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks! That perfectly answered my question.

-x

On 8/21/07, Kevin Hao <haokexin@gmail.com> wrote:
> > I am curious how Linux convert an fd to the pathname?  Does it
> > recursively walk back from current dentry to the root?
> Using d_path.
> > Can someone point me to the right place in the kernel where this
> > functionality is implemented?
>
 may be the function you want.
>
