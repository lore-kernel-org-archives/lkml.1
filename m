Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbZGNDmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbZGNDmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 23:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbZGNDmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 23:42:09 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:59046 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbZGNDmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 23:42:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=i6E0vUVuQBEng6M8cAjJVx9fCWqMl8G2Yfl1eCK0c4s2tRd0h8ru3dCQQLu36401cK
         e66nKiwnlzUJ0y5zYrKXcDQzXuBaRxl0KleGAFJicCHr9P19KqQMKGTX9Ub+Vy1XXMPh
         /bmajjOrKeZUv68kN1hqLMas1xVLz1I0lh5S8=
Date: Tue, 14 Jul 2009 08:13:53 +0430
From: Ali Gholami Rudi <ali@rudi.ir>
To: Dave Airlie <airlied@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       fbdev <linux-fbdev-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Righi <righi.andrea@gmail.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Philippe De Muyter <phdm@macqel.be>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] fbdev: add fillrect and copyarea ioctls
Message-ID: <20090714034353.GA1280@lilem.mirepesht>
References: <20090713151709.GA1297@lilem.mirepesht>
 <20090713084058.547e88f0@infradead.org>
 <20090713162559.GA1279@lilem.mirepesht>
 <21d7e9970907131746q4f1a34efw9d3e6efaa78aea34@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <21d7e9970907131746q4f1a34efw9d3e6efaa78aea34@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-26)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie <airlied@gmail.com> wrote:
> On Tue, Jul 14, 2009 at 2:25 AM, Ali Gholami Rudi<ali@rudi.ir> wrote:
> > Arjan van de Ven <arjan@infradead.org> wrote:
> >> can we turn this around, is there a reason to add them?
> >> or in other words, how / where would these be used ?
> >
> > User-space programs that use framebuffer directly can use them.  I was
> > writing a simple framebuffer virtual terminal (using libfreetype for
> > fonts; like fbterm); scrolling and painting boxes would be faster if
> > there was someway of using hardware accelerated operations.  I think
> > other similar programs can benefit, too.
> 
> The general opinion is we should keep acceleration in userspace if at
> all possible.

I see.  The line between user- and kernel-space for graphic applications
is very blurred to me :-)

> Not all hw can implement these usefully in the kernel, directfb

AFAICT, many major ones like intelfb, radeonfb and nv implement them and
those that can't, use a software implementation.  You mean they are
unreliable or that there is little performance improvement because of
the way those operations are implemented in the kernel?

> already does some
> things for this.

Sometime ago I did try running directfb on a radeon r300 and it failed.
I didn't try hard to see what's wrong but I got the impression that
userspace apps are not good at using the hardware directly.

	Ali
