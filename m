Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbXDUXUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbXDUXUq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 19:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbXDUXUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 19:20:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:47014 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbXDUXUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 19:20:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=b5qRk1yTYPk+Vq8ZTOPBNjLjg+K7mGaAd3UT5uM1NGjA1weEQWq0hI7ddkW9WxkowyRthObzpL2ZnUFz+Ely8VUVbg3AM4Zm7W771CYPNE/YsfZrlXG+2I2F9tQ+fUqss4oudKBxnfiY/0tuiMdLHYOl+aNqChVA6fRPV3WSHdw=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: "Tom Strader" <tom.strader@xilinx.com>
Subject: Re: unable to run busybox /sbin/int
Date: Sun, 22 Apr 2007 01:20:28 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org
References: <20070419190009.039B1A080F8@mail28-fra.bigfish.com>
In-Reply-To: <20070419190009.039B1A080F8@mail28-fra.bigfish.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704220120.28962.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom.

On Thursday 19 April 2007 21:00, Tom Strader wrote:
> This is the final output from my kernel as I try to launch busybox
> (/sbin/init is linked to /bin/busybox)
> As it launches the kernel looks for libraries which do not exist (not
> sure why), but it appears to find /lib/libcrypt.so.1 and /lib/libc.so.6
> but the system does not output after that.  I can press keys on the
> keyboard and there are echoed to the screen, I can also use the control
> characters C-c, C-s, C-q, and so on and I see kernel messages indication
> the uart_flush_buffer(0) is being called but busybox does not appear to
> start.  Here is my kernel output, any suggestions would help. Thanks.

Ok, here we go again.

Does "hello, world" program works
as init, do you see its output? (init=/path/to/hello_world)

If no: what is your console, serial I think? How do you specify
it on kernel command line?

If yes: does init=/bin/sh work?
--
vda
