Return-Path: <linux-kernel-owner+w=401wt.eu-S932266AbXHLQv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbXHLQv0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 12:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbXHLQvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 12:51:18 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:9441 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbXHLQvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 12:51:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=db41yjUrGIwOpWO5Ze6p08h+zGAm526iUCDS6OuA9rYWUxxQN/AQRE6pjfyLnIPT1CtuLe24141645g6ji8uq4h+Q45Y5mK4hZngFJwUPqJrgWUsYF96AfXCxfnoPKu+6+bt8UnmxZWLwTTVL4AE9osIFQyqT/xF0kKY3cFnsc8=
Message-ID: <6cf66ee10708120951l62d70bcbob568010efcfeecb7@mail.gmail.com>
Date: Sun, 12 Aug 2007 06:51:15 -1000
From: "charles gagalac" <charles.gagalac@gmail.com>
To: dean@arctic.org
Subject: Re: [BUG] Kernel panic - not syncing: VFS
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <6cf66ee10708112034j65689eacm6a72c6d019e9f62f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6cf66ee10708112034j65689eacm6a72c6d019e9f62f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/11/07, charles gagalac wrote:
> i'm getting the following kernel panic when booting:
>
> Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
>
> a bisect generated the commit below:
>
> 3320ad994afb2c44ad34b3b34c3c5cf0da297331 is first bad commit
> commit 3320ad994afb2c44ad34b3b34c3c5cf0da297331
> Author: dean gaudet
> Date:   Fri Aug 10 22:30:59 2007 +0200
>
>     x86: Work around mmio config space quirk on AMD Fam10h
>

fixed with commit c1502e28346fd3b9955ce654c96212c4748d900d, i believe.  thanks.
