Return-Path: <linux-kernel-owner+w=401wt.eu-S932626AbZCZTfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626AbZCZTfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 15:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932576AbZCZTfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 15:35:20 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:37159 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400AbZCZTfS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 15:35:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Fpew/N8Wo8mllCIEuQPUUC9yJ1ZtAS6VAYXm0X077BYlGzVG8uBJ6rN7U/VXc3IFPH
         vUGEQti9ykzxPbzerSQ4Pa7HuyuQqmZi5l7tVowWXAZG9pTDFkAu4OutpiLf3gRbTfFT
         IINqq4X6DyP2Nf+jD/yYGjaTA1nJDNVFXFmuk=
MIME-Version: 1.0
In-Reply-To: <COL112-W81AF4A8C222B9941D8295FC8910@phx.gbl>
References: <COL112-W81AF4A8C222B9941D8295FC8910@phx.gbl>
Date: Thu, 26 Mar 2009 20:35:15 +0100
Message-ID: <c384c5ea0903261235sf1a4440q6fb5f38c983770bc@mail.gmail.com>
Subject: Re: recommended programming practices for writing (was Linux 2.6.29)
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Adam Turk <bofh1234@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Adam,

On Thu, Mar 26, 2009 at 8:03 PM, Adam Turk <bofh1234@hotmail.com> wrote:
>
> I have been reading the Linux 2.6.29 thread with interest.  I have written several (10 or so) C programs that write large amounts of data (between 1 and 2 GB file sizes are common).  A snippet of code looks like this:
>
> I learned C about 15 years ago and there was no mention of a fsync.  My C book doesn't mention fsync either.  Granted I have written only 25-30 applications in the last 15 years or so so I am not an expert C programmer.
>

Your question is really off-topic for the Linux Kernel mailing list,
but let me point you somewhere else:

There is (1) the C library and (2) the functions provided by your
operating system. Linux follows to some extend the POSIX functions for
(2).

A good read is the book "Linux Systems Programming" if you want to go
beyond what the C library offers, for starters.

Regards,
-- 
Leon
