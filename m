Return-Path: <linux-kernel-owner+w=401wt.eu-S1761006AbXKDPNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761006AbXKDPNR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 10:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757163AbXKDPNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 10:13:05 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:64395 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205AbXKDPNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 10:13:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=awfTZoXJWpYDP+KHU4G65d34oTPUIKLZNqn5NLlGpAvsxpsnH8HHE8uuZGKRmPt3KBDOF9If8Uic64AGnq+6mHeu/MPfZNsKWbkSt8FKG9ozQ/tTvp8JfByTXIEjgwltgWp+Hc6ekLE849I2jfgHEcW0o4JTj+o6RwEsg8igrdQ=
Message-ID: <e2e108260711040713g2802b262sda75672f8e0f50f6@mail.gmail.com>
Date: Sun, 4 Nov 2007 16:13:00 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Andrew Haley" <aph@redhat.com>
Subject: Re: Is gcc thread-unsafe?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Tomash Brechko" <tomash.brechko@gmail.com>
In-Reply-To: <18219.17505.443550.620503@zebedee.pink>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18210.2314.57767.962503@zebedee.pink>
	 <MDEHLPKNGKAHNMBLJOLKCELIHMAC.davids@webmaster.com>
	 <18215.1394.294830.944162@zebedee.pink>
	 <e2e108260711020829p5994f79bp48ca35a1ce84ff03@mail.gmail.com>
	 <18219.17505.443550.620503@zebedee.pink>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/07, Andrew Haley <aph@redhat.com> wrote:
> Bart Van Assche writes:
> > On 10/30/07, Andrew Haley <aph@redhat.com> wrote:
> > > That's what the proposed standard language says, kinda-sorta.  There's
> > > an informal description at
> > > http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2338.html.
> >
> > There is other important information in the cited text. A.o. it is
> > explained that register promotion of potentially shared variables
> > can introduce data races. Or: register promotion can introduce bugs
> > in multithreaded software when compiled with optimization
> > enabled. Are there any register promotion transformations
> > implemented in gcc that can introduce data races in multithreaded
> > software ?
>
> I expect so.  We're going to have to audit this whole enormous code
> base to find them all and take them out.
>
> Note that some of these optimizations have been around since gcc 3.4.

Has it already been decided who will do this audit, and when this
audit will happen ? Has a target date been set when this audit should
be complete, or is the completion of this audit a requirement for the
release of a specific gcc version ?

And if there would exist register promotion transformations in gcc
that can introduce data races, which would be the optimization levels
that enable these transformations ?

Bart Van Assche.
