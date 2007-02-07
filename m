Return-Path: <linux-kernel-owner+w=401wt.eu-S965487AbXBGFbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965487AbXBGFbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 00:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965642AbXBGFbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 00:31:23 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:20537 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965487AbXBGFbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 00:31:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bh9QKawhl0ab/6xJfYrWda1i7ISWOab6THezSeWzo+6eD0yCZsIkI06vHUsV+opNH44YXESb4I8FDMg+sb9w4UsbnRdcilxRUCDx5GZNbi94TqwTmfoEuCo9UPrwtm23gH3PuOOJp/M6CwVfNOn5OQbZ2oMKmPfFPlzzF9wQOrM=
Message-ID: <5157576d0702062131u3365881bw87a29eaabac69c40@mail.gmail.com>
Date: Wed, 7 Feb 2007 08:31:20 +0300
From: "Tomasz Kvarsin" <kvarsin@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH]: warrning fix: unsigned->signed
Cc: viro@zeniv.linux.org.uk, axboe@kernel.dk, linux-kernel@vger.kernel.org
In-Reply-To: <20070206140936.24bbaded.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5157576d0702061339w28adbf5fp2dbc5e86661d894@mail.gmail.com>
	 <20070206140936.24bbaded.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I uses gcc "trunk" with -Wconversion,
 because of they finaly implement warrning for such things:
uint16_t a;
uint8_t b;
b = a;
see
http://gcc.gnu.org/wiki/NewWconversion

On 2/7/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 7 Feb 2007 00:39:45 +0300
> "Tomasz Kvarsin" <kvarsin@gmail.com> wrote:
>
> > While compiling my code, I always get bunch of warrning from headers,
> > here is fix for them:
> > __getblk is alawys called with unsigned argument,
> > but it takes signed, the same story with __bread,__breadahead and so on.
>
> The patch seems OK, but I'm curious to know why you're seeing this warning
> and nobody else is.  Are you using a compiler other than gcc?  If gcc,
> which version?  Did you add any new compiler options?
>
> Thanks.
>
