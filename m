Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbXHSWU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbXHSWU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 18:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755831AbXHSWTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 18:19:47 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:55164 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755AbXHSWTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 18:19:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KgGrMvZecRVxc3IywRzkW6HFARDKpuOKYKvwWSVxuJC947snk9uHftZNbAqvVOkIoPnPvFNojpSuYyqSYzzYQt3JwdBYYFEIHDUOVP9/E+RMzQnMnNqKREdYeoAdu1acDaPXSYn28fmv7hlNKt+yG72vlDpPoTg5MXD6mqJK1aw=
Message-ID: <9a8748490708191519s73b5ab01w10295dab4083de96@mail.gmail.com>
Date: Mon, 20 Aug 2007 00:19:44 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Joe Perches" <joe@perches.com>
Subject: Re: convert #include "linux/..." to #include <linux/...> [PATCH]s follow
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Andy Whitcroft" <apw@shadowen.org>
In-Reply-To: <1187561864.4200.136.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1187561864.4200.136.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/08/07, Joe Perches <joe@perches.com> wrote:
> There are several files that:
>
> #include "linux/file" not #include <linux/file>
> #include "asm/file" not #include <asm/file>
>
> Here's a little script that converts them:
>
If you've actually checked that such conversions are correct and work
fine, how about a patch (or patches)?

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
