Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbZGMQYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbZGMQYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 12:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756473AbZGMQYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 12:24:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:54235 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376AbZGMQYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 12:24:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Dqq+JlPSIWykwyfLHPiigA1aoc9GlnNCEiLZo4uABVxuTIaLJJLrJzosKpyDUyAXxu
         jEcE8HyepDrSdNmSel/sXOvjb1F0CYpWjGrF088CHsFMM5/Mx9Wn1b2zDVsbWKtZ6guf
         Ejg4WfIKbwfvUe1rF9hgNj97gId8TGG0sY/3k=
Date: Mon, 13 Jul 2009 20:55:59 +0430
From: Ali Gholami Rudi <ali@rudi.ir>
To: Arjan van de Ven <arjan@infradead.org>
Cc: fbdev <linux-fbdev-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Righi <righi.andrea@gmail.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Philippe De Muyter <phdm@macqel.be>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] fbdev: add fillrect and copyarea ioctls
Message-ID: <20090713162559.GA1279@lilem.mirepesht>
References: <20090713151709.GA1297@lilem.mirepesht>
 <20090713084058.547e88f0@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090713084058.547e88f0@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-26)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> wrote:
> On Mon, 13 Jul 2009 19:47:09 +0430
> Ali Gholami Rudi <ali@rudi.ir> wrote:
> > Is there any reason for not adding these ioctls to fbdev?  I searched
> > the net and couldn't any.  Anyway, these patches simply implement
> > those ioctls.
> > 
> 
> can we turn this around, is there a reason to add them?
> or in other words, how / where would these be used ?

User-space programs that use framebuffer directly can use them.  I was
writing a simple framebuffer virtual terminal (using libfreetype for
fonts; like fbterm); scrolling and painting boxes would be faster if
there was someway of using hardware accelerated operations.  I think
other similar programs can benefit, too.

	Ali
