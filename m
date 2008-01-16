Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbYAPQad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbYAPQad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 11:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYAPQaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 11:30:25 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:22627 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbYAPQaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 11:30:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=vZ5YpuNYu+q+mrTzRPO9Ih8+RK+iVtpqs9eJnznh87If3pGe0bKgX+mBxtyDUgftvUgB9rEfICldeiwP/NB8KDJzuBi3X6HnYpliFrv157DoVg+3l8bjRIl0ZnL5kpHq0LEBIY9z7WoPn68hS8EtImLVBNaLox8CncJjR6AHKeA=
Message-ID: <2c0942db0801160830j72c0fc77xc4cc9e7fd676d78a@mail.gmail.com>
Date: Wed, 16 Jan 2008 08:30:21 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
Subject: Re: Updatedb hangs Kernel 2.6.22.9-cfs-v22
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <478B7F9F.3020209@mandic.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <478900FF.2000706@mandic.com.br>
	 <2c0942db0801121025h7f22d716s657af75ce7603af0@mail.gmail.com>
	 <478B7F9F.3020209@mandic.com.br>
X-Google-Sender-Auth: e798c6e6535ab546
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 14, 2008 7:28 AM, Renato S. Yamane <renatoyamane@mandic.com.br> wrote:
> Ray Lee escreveu:
> > On Jan 12, 2008 10:03 AM, Renato S. Yamane wrote:
> >> I can't use updatedb in Debian Etch (stable) using customized Kernel
> >> 2.6.22.9-cfs-v22.
> >>
> >> When I ran updatedb, after ~1 minute my system hangs and "caps lock" LED
> >> is blinking. No log is registered.
> >
> > Please switch out of X11 to a text mode console (CTRL-ALT-F1), and run
> > updatedb there. Capture the oops with a digital camera, and post a
> > link to the picture (not the picture itself!) to the list. Or, write
> > down the oops carefully, and post the text.
>
> I see a infinite loop and is very fast, so I can't capture errors messages.
> None is registered in /var/log/*

Well, that's very odd. Please also try the latest CFS backport to see
if that solves the problem.

Ray
