Return-Path: <linux-kernel-owner+w=401wt.eu-S936623AbXHIGbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936623AbXHIGbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 02:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935923AbXHIGbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 02:31:37 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:62454 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761258AbXHIGbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 02:31:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ddX4pOiPVrcGsMAfnow87lSl6/Lje8FUiQxL4ZwZHuGO6s3Vc/VYfI+5Zrsg9Op6dHd1o6nk0APoOynC/gznNT+oyuZQQp5hw2pcdtNGZ0pH8Q8YWokIVWi6dDytXzoxVIM3rIMUv4KA7epyA+0aZ5Anq+J4zXkRzCAP1fWGnB0=
Message-ID: <4104961b0708082331h4f868113g9a9e76905883619b@mail.gmail.com>
Date: Thu, 9 Aug 2007 14:31:35 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Question on IS_ERR
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46BAB078.4020307@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4104961b0708082236if0c1199l2bbc468e9d582a08@mail.gmail.com>
	 <46BAB078.4020307@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/07, H. Peter Anvin <hpa@zytor.com> wrote:
>
> No.  There is no requirement that the pointer is page-aligned.  The last
> page of the address space is (in the Linux kernel) invalid by
> definition, so there are in effect three kinds of pointers in the Linux
> kernel: valid pointers, NULL, and ERR_PTR()s.
>
>        -hpa
>

Regarding "The last page of the address space is invalid by definition",
I am wondering why do we define the last page as invalid.
The reason for defining this is just because we want to take use of
the error number handling?

Regards
Jason
