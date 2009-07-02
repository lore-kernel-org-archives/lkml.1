Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbZGBJLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbZGBJLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 05:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbZGBJK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 05:10:59 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:42421 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbZGBJK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 05:10:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UxQKy+vs5JZ6XFcW2q5vmoQP9sMY6UcbYOonxNkkIP5tC4e2LrXJmwZl2xPruujRGp
         Yeu9PMO/JSykAxKf0zy8A299hFxBVidz132I55xUaKOrd5LmRTM1j5n2DhYaDFCO6UnT
         QSt9D+xMuGXfoc50v9WLsFoU4DBY/qtSeIyww=
Date: Thu, 2 Jul 2009 17:13:09 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
Message-ID: <20090702091309.GB6372@cr0.nay.redhat.com>
References: <412e6f7f0907020036y76abbc7du99c7b695f725be4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <412e6f7f0907020036y76abbc7du99c7b695f725be4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 03:36:41PM +0800, Changli Gao wrote:
>Linux also uses pipes as references of kernel buffers. In that case,
>only one RW file descriptor will be enough, instead of inventing a new
>system call, I think extending the existing pipe() is a better idea.
>If pipe is passed with a NULL pointer, one RW file descriptor is
>returned. I have checkd the other architectures except of x86, it
>seems that not all of the platforms implement this system call with
>the prototype: int pipe(int fd[2]); and changing glibc is needed. Is
>it possible to extend pipe() in this way?
>

Why? Why do you need this feature?
