Return-Path: <linux-kernel-owner+w=401wt.eu-S1763768AbXHQUVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763768AbXHQUVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 16:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbXHQUVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 16:21:43 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:42411 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbXHQUVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 16:21:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sNXPOnrQN7VYam8hN8ieDUVX+Eqy98eellfwwzbEilW/G2eYnD8wTljgQhyG5mhLr6NCgHV7zsowb4cS8hjsBJRERtWBRLskVLjFXP9dq8wqDgfT4v7mAZ9Ll7bbcipvl+C/gDaw5AHQHEX4lwFiebo7KcnFJH0uMNRvUPNn0ik=
Message-ID: <8bd0f97a0708171321g3460312fwf2b6cb998845ea85@mail.gmail.com>
Date: Fri, 17 Aug 2007 16:21:40 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 02/12] Blackfin arch: Add label to call new GPIO API
Cc: "Bryan Wu" <bryan.wu@analog.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Michael Hennerich" <michael.hennerich@analog.com>
In-Reply-To: <8bd0f97a0708171319q71b5a117v8882f4fb70d2dc43@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11865441373719-git-send-email-bryan.wu@analog.com>
	 <200708171124.54839.david-b@pacbell.net>
	 <8bd0f97a0708171245j74e856e0uce009de16c00f517@mail.gmail.com>
	 <200708171309.25529.david-b@pacbell.net>
	 <8bd0f97a0708171319q71b5a117v8882f4fb70d2dc43@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/17/07, Mike Frysinger <vapier.adi@gmail.com> wrote:
> as Michael pointed out, in the Blackfin world we tend to keep things
> very dynamic as we have dev systems which allow for dropping in of
> optional cards at will, so doing this in the bootloader is way too
> inflexible.

oh, and another [smallish] data point.  the Blackfin processor has a
small bootrom on it that could be likened to a very micro bios.  so
it's possible to actually boot the linux kernel straight without a
boot loader.  send the kernel over the UART to a Blackfin and watch it
go go go :)
-mike
