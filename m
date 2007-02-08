Return-Path: <linux-kernel-owner+w=401wt.eu-S1423289AbXBHVC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423289AbXBHVC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 16:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423322AbXBHVCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 16:02:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:13774 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423289AbXBHVCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 16:02:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=EmUqPwwzA7AZTuZn/b8Ef/6elRetC9EXA5yzpEqoCK899Wq2B8gpCvjz+4fsUoOhkFRC1FK/PCJaTReIjRl2KwVxEnhgEy4QyP+AAnjNNIK0P8fIbxqInOLHzmQwRHuUJK7x93aiw1zI/r3daH0GqHk3557ox6NqtJuXb+6vQrI=
Message-ID: <84144f020702081302x351a9937ofc6e722b5c5cada3@mail.gmail.com>
Date: Thu, 8 Feb 2007 23:02:11 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Jeff Dike" <jdike@addtoit.com>
Subject: Re: [uml-devel] UML hang with 100% CPU
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
In-Reply-To: <20070208195711.GA6607@ccure.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1HFEIB-0000nJ-00@dorka.pomaz.szeredi.hu>
	 <20070208195711.GA6607@ccure.user-mode-linux.org>
X-Google-Sender-Auth: 19c30dbbc19ec9f4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Feb 08, 2007 at 07:46:47PM +0100, Miklos Szeredi wrote:
> > It boots fine, then usually just after logging in and before starting
> > the shell (but sometimes after the shell started) it gets into some
> > loop.  Looking at the strace shows that two processes are
> > sending/receiving single '\0' bytes on some sockets endlessly.
> >
> > Does this ring a bell?

On 2/8/07, Jeff Dike <jdike@addtoit.com> wrote:
> No, it doesn't.  This is a strace on the host, I take it?
>
> Can you get backtraces from the processes?

Just a datapoint: I had a similar problem with UML hanging on
2.6.20-rc something _host_ kernel whereas 2.6.19 worked fine. That was
with Gentoo userspace which I don't have anymore.
