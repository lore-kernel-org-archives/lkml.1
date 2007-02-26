Return-Path: <linux-kernel-owner+w=401wt.eu-S1030294AbXBZPWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030294AbXBZPWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 10:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030298AbXBZPWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 10:22:13 -0500
Received: from wx-out-0506.google.com ([66.249.82.239]:36960 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030294AbXBZPWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 10:22:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DFTlzY/MczsunWoeVzmzoWIEw69Md/XBOVE242a8QS38lLSH1aYR7KL9WyJC5BNJlrHTFeNnKjfUekOR35PHW22gim0FwMGRvz7b659sycTGB367PGyAJcVGxbSUqnAWcEX9tOh7da/2QwEzmWATOwAjNRdbPhzWUZpbT8gMZP0=
Subject: Re: tdfx framebuffer garbles display in 2.6.19.5
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: DervishD <privado@dervishd.net>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
       Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>
In-Reply-To: <20070226144744.GA3615@DervishD>
References: <20070226144744.GA3615@DervishD>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 26 Feb 2007 23:24:31 +0800
Message-Id: <1172503471.20842.14.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-26 at 15:47 +0100, DervishD wrote:
>     Hi all :)
> 
>     From time to time, the tdfxfb driver from 2.6.19.5 (sorry, I cannot
> test in 2.6.20.x because it doesn't compile, the infamous BDF negative
> offset problem) garbles the display, leaving only a lot of thin lines,
> just like sync was lost. The display can be repaired by switching to
> another console, but this is annoying. This happens with a Voodoo 3
> 3000, using 800x600x8@100 mode.
> 
>     Anyone has this problem? Can it be solved changing anything?
> 
>     Raúl Núñez de Arenas Coronado

Try fbset -a -vyres 600 first and let us know of the result.

Tony


