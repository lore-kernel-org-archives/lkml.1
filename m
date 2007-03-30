Return-Path: <linux-kernel-owner+w=401wt.eu-S932078AbXC3WG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbXC3WG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 18:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932185AbXC3WG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 18:06:26 -0400
Received: from smtp-out.google.com ([216.239.33.17]:2828 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078AbXC3WGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 18:06:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=CglBD/xvDBf+CeNnbHvvnEMdv6aUaS9AfcJnHVYXYIJkHvgMWJvG+SElD2LG7sTES
	37dBaV7W33Pha0Tk/vfqA==
Message-ID: <b040c32a0703301506q17509843h1309a4132634154a@mail.gmail.com>
Date: Fri, 30 Mar 2007 15:06:03 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch] remove artificial software max_loop limit
Cc: "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070330141524.5f6cff29.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b040c32a0703300053u110063b0u80ee0e7b9dd158c2@mail.gmail.com>
	 <b040c32a0703300148w479cf4cdw667cf464edf7c725@mail.gmail.com>
	 <Pine.LNX.4.61.0703301105190.31834@yvahk01.tjqt.qr>
	 <b040c32a0703300225r3f8b1daah2f95e8af26c0d867@mail.gmail.com>
	 <20070330141524.5f6cff29.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/30/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> So..  this change will cause a fatal error for anyone who is presently
> using max_loop, won't it?  If they're doing that within their
> initramfs/initrd/etc then things could get rather ugly for them.

probably, if they access loop device non-sequentially.


> I don't know how much of a problem this will be in practice - do people use
> max_loop much?

I don't know either.


> btw, did you test this change as both a module and as linked-into-vmlinux?

as linked-into-vmlinux.  why do you ask?  It breaks if it is module?
I made last minute change to a mutex name and shamely posted without
doing a compile test.  Besides that, is there something else breaks?

- Ken
