Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbYD2FtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbYD2FtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 01:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbYD2FtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 01:49:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:12829 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbYD2FtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 01:49:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=T2CbUUtwOZoQXTtYCfj6LE7ypd7SJZ4iLofjBD9+hZgfvn1yPJy0zlgA7Xam51yLqqVusHkDTt1fRHPbzu6iBuCx/kZujKWYivIR9/SDIE6GsRgcOdviGhe928mbavNeKQGcY3LeOCiwnXIehroVrqM5HJMMTbCrIz9XvqKCg3k=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: standalone kbuild's homepage?
Date: Tue, 29 Apr 2008 07:48:12 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org
References: <200804290503.50545.vda.linux@googlemail.com> <20080429051150.GB2262@uranus.ravnborg.org>
In-Reply-To: <20080429051150.GB2262@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804290748.12101.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 April 2008 07:11, Sam Ravnborg wrote:
> On Tue, Apr 29, 2008 at 05:03:50AM +0200, Denys Vlasenko wrote:
> > Hi Sam, folks,
> > 
> > IIRC apart from in-kernel build system there is a "standalone"
> > one, which is targeted at other projects wishing to reuse
> > this excellent infrastructure.
> 
> Unfortunately not. I have hoped to find time/energy to
> extract the useful bits and do something so I could
> offer kbuild to other projects.
> But I do not see this happening soon :-(

So far busybox uses almost unmodified kernel kbuild,
mostly ignoring all the unused extra machinery (modules, System.map etc).

Works great. I mean, _really_ great. Thanks!

I found an old mail:

http://busybox.net/lists/busybox/2006-September/024081.html

>Also I notes that you took scripts/Makefile.build verbatim.
>That file contains a lot of kernel cruft and you would be in a much
>better position using scripts/Kbuild.klibc from klibc.

Aha! this can be it.
--
vda
