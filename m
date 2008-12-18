Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753020AbYLRUyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbYLRUyU (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 15:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbYLRUx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 15:53:59 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:37360 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbYLRUx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 15:53:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tJGM8TKaM78jVxY2KIqkIdO28iCiJcpO3Go9+ThJ7GkBQn+vvxFDJbnTHgGOHvkymZ
         P6lNRUxK/E02VgSuPMNU8CtNDl5JWdxwK10t18wGLStlbTo4Q2MWVDNzJg/8lDMLTUL/
         NDATieTfW+GHPjX4tWdpbjpS+UZUbTxDTS7Qk=
Subject: Re: [PATCH-2.6.28 final] byteorder: fix new headers for userspace
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, bluebird@gentoo.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0812181246420.14014@localhost.localdomain>
References: <4943DAD6.7070402@gentoo.org>
	 <20081216.011334.124918024.davem@davemloft.net>
	 <1229564779.6481.26.camel@brick>
	 <alpine.LFD.2.00.0812181208070.14014@localhost.localdomain>
	 <alpine.LFD.2.00.0812181246420.14014@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 18 Dec 2008 12:53:55 -0800
Message-Id: <1229633635.6481.31.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-18 at 12:47 -0800, Linus Torvalds wrote:
> 
> On Thu, 18 Dec 2008, Linus Torvalds wrote:
> > 
> > I think it would be better to just make it a config option, call it 
> > CONFIG_[LITTLE|BIG]_ENDIAN and set it up in the architecture Kconfig file. 
> > I think some of the people who can set it dynamically (or where it depends 
> > on the target machine) already effectively do that.
> 
> Never mind, since we end up having to export it to user space (do we?) we 
> can't depend on the config.h file, nor can we pollute the name space.
> 
> Oh well.

I'm still having a bit of a think on this if we can avoid it.  But I
think we're stuck with needing a different symbol. :-/

Harvey

