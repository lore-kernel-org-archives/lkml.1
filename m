Return-Path: <linux-kernel-owner+w=401wt.eu-S1760900AbXGLPCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760900AbXGLPCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 11:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763087AbXGLPCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 11:02:18 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:53157 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762290AbXGLPCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 11:02:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H3WZfomKTFUrpOj709WwzjZlSCQZ422uJiKwT43u1+QbGz/lFVzuvhld/HRMKnot7s1y6iHvttNEHnQAfxfCe90wsn96j8qhx82GLpkC0kyiGIeKdX4PIc/FYBZbuxhhq4W/a+fo9kyWmVxUc8Jg6/sxM6E4LNFmnWxIfODzCWA=
Message-ID: <78ecab220707120802p11ab3e1fye497f4107fe18c1d@mail.gmail.com>
Date: Thu, 12 Jul 2007 11:02:15 -0400
From: "Mark Shelby" <mshelby1@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: kernel autoconfig option?
In-Reply-To: <Pine.LNX.4.64.0707121635120.25352@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <78ecab220707120718q7cfcff43u66f80711c7ec1005@mail.gmail.com>
	 <Pine.LNX.4.64.0707121635120.25352@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

That's an excellent idea. I am still thinking along the lines of
"idiot proof simplicity." It would be nice to have a configure script
that scanned your system board, sound card/chip various input ports,
etc, and went ahead and preselected those to build when you type
"make.

If you could combine this with the make "allmodconfig" command in a
user friendly interface, I think you'd really be on to something!
--as long as it's still configurable after the preselected choices are
made.


On 7/12/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Jul 12 2007 10:18, Mark Shelby wrote:
> >
> > Would it be possible to design a program to scan your existing system
> > hardware and pre-select your onboard hardware options within the
> > kernel config menus?
>
> > Am I just crazy, or wouldn't this idea mke a lot of sense? Wouldn't it
> > pretty much make the kernel "idiot proof" when installing from source?
>
> Why not just use `make allmodconfig`? If you happen to suddenly have a new
> device you never had before (and I can assure you: this happens!), you
> already have all modules.
>
>
>
>        Jan
> --
>
