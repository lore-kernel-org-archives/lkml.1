Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbZJ3D2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbZJ3D2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 23:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbZJ3D2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 23:28:11 -0400
Received: from mail-ew0-f209.google.com ([209.85.219.209]:40251 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbZJ3D2K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 23:28:10 -0400
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Oct 2009 23:28:09 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=JI9wI5F16BA4SY9bvxHHefGk42pDG9RvOWUxh0/+sKvIftDjN1tXaJX6xjLk17VnxP
         ZxkrerGWA/xcAauhx5/Gw3IWGl5VoysVRL6buHvbhp8m77C9DDyvwn39LEEC/8aqpk9L
         5uW8bAnR1ih/8cLPfag6fvTGsqBGiCKKhOvHg=
MIME-Version: 1.0
In-Reply-To: <1254691822.21044.9.camel@laptop>
References: <Pine.LNX.4.64.0910041229300.20203@digraph.polyomino.org.uk> 
	<1254691822.21044.9.camel@laptop>
From: Ulrich Drepper <drepper@gmail.com>
Date: Thu, 29 Oct 2009 20:21:02 -0700
Message-ID: <a36005b50910292021y392075d5lddc620e3bdfc3ede@mail.gmail.com>
Subject: Re: F_SETOWN_EX and F_GETLK64 conflict
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Joseph S. Myers" <joseph@codesourcery.com>, linux-api@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <onestero@redhat.com>,
       Stephane Eranian <eranian@googlemail.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 4, 2009 at 14:30, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>  arch/alpha/include/asm/fcntl.h |    4 ++--
>  include/asm-generic/fcntl.h    |   19 +++++++++++--------
>  2 files changed, 13 insertions(+), 10 deletions(-)

This patch looks fine:

Acked-by: Ulrich Drepper <drepper@redhat.com>


Linus, can you please apply it in whatever form so that we know the
value of the constants?
