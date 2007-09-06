Return-Path: <linux-kernel-owner+w=401wt.eu-S1757621AbXIFLeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621AbXIFLeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 07:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbXIFLeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 07:34:24 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:11725 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbXIFLeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 07:34:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AUaR2CsgrTLmkMXHroyiV+ITo9C7ofQbrauL/L+X7I+nrFVWJJi/y2scLUbW08/45vRTp/hi5X44GdbzY2S2yLfhxhAFuml5pmN/LMG1v949kuy++G2sNpQhLGC4GjKrRMjkab5U1NWqXrEFN5tuwSsVtlyph4JgI7zfZZvAzus=
Message-ID: <a36005b50709060434u35d8db01n7cc448e98fdbdd37@mail.gmail.com>
Date: Thu, 6 Sep 2007 04:34:20 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Michael Kerrisk" <mtk-manpages@gmx.net>
Subject: Re: O_CLOEXEC / MSG_CMSG_CLOEXEC documentation
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <46DEFD3F.8020502@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705312320.l4VNKS44030545@shell0.pdx.osdl.net>
	 <46DEFD3F.8020502@gmx.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/5/07, Michael Kerrisk <mtk-manpages@gmx.net> wrote:
>     O_CLOEXEC (Since Linux 2.6.23)
>           Enable   the  close-on-exec  flag  for  the  new  file
>           descriptor.  This is useful in multithreaded  programs
>           since  using  a separate fcntl(2) F_SETFD operation to
>           set the FD_CLOEXEC flag does not suffice to avoid race
>           conditions  in multithreaded programs where one thread
>           opens a file descriptor at the same  time  as  another
>           thread does a fork(2) plus execve(2).

Correct, although you might want to reconsider the repetition of "in
multithreaded programs".

Plus, it's also useful in other programs since it avoids the
additional system call to fcntl.
