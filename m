Return-Path: <linux-kernel-owner+w=401wt.eu-S1761219AbXE1HrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761219AbXE1HrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 03:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbXE1HrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 03:47:10 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:35052 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbXE1HrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 03:47:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=M2hGFBzreEq4oi8sWVndoVAiA7emmIdeasAqTB9Qijvy/5JnE8DCWedFHf49Mc1Bh0UEWNsXAmoePN54ZlUaG1VWLuRhhNATNNf/+xMwVh53fBcmJO/mR6LtobTn2TUEmYxRrbHtlnNNrHR0/je6PwEw2nVPjpkKpgSh/CfSNPg=
Message-ID: <84144f020705280047t55cec1c3hb7b1921b9478a954@mail.gmail.com>
Date: Mon, 28 May 2007 10:47:06 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Tero Roponen" <teanropo@jyu.fi>
Subject: Re: tty-related oops in latest kernel(s)?
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <84144f020705280022lf3902caj1def02ed56e0bff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705271200360.4955@jalava.cc.jyu.fi>
	 <84144f020705280022lf3902caj1def02ed56e0bff@mail.gmail.com>
X-Google-Sender-Auth: 1978a39faec89176
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Can we have your .config please? Also, could you work out the file and
> line number of vt_ioctl+0xda8/0x1482 like this:
>
> gdb vmlinux
> (gdb) l *0xc021e50e

Btw, this only works if you have CONFIG_DEBUG_INFO set. In case it
wasn't, please do:

- Enable CONFIG_DEBUG_INFO
- make vmlinux
- gdb vmlinux
(gdb) p vt_ioctl
(gdb) l *(0x<address of vt_ioctl> + 0xda8)
