Return-Path: <linux-kernel-owner+w=401wt.eu-S933318AbYCFRf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318AbYCFRf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 12:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765712AbYCFReo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 12:34:44 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:8598 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765043AbYCFRek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 12:34:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=e40eGOohObMnUv4XrLSKjwSbu+xi2e2ej+jgA1K4g7Y/4Zt/TelzqA8+P2WWY7byC4khvI15PWuGYB6rNSr43EPW5E9zoFAercEOXYa4PHVjMAr9b3U6LLDINM8plsIBCGk7praWlY0lYgBEvDmCQ9Qk1u0af1uTZvoGdgkDnXM=
Message-ID: <6dc9ffc80803060934q3df9b5b5gf336b1ed0af16820@mail.gmail.com>
Date: Thu, 6 Mar 2008 09:34:35 -0800
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction flag
Cc: "Jakub Jelinek" <jakub@redhat.com>, NightStrike <nightstrike@gmail.com>,
       "Olivier Galibert" <galibert@pobox.com>,
       "Chris Lattner" <clattner@apple.com>, "Michael Matz" <matz@suse.de>,
       "Richard Guenther" <richard.guenther@gmail.com>,
       "Joe Buck" <Joe.Buck@synopsys.com>, "Jan Hubicka" <hubicka@ucw.cz>,
       "Aurelien Jarno" <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
In-Reply-To: <47D0271F.4070705@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <738B72DB-A1D6-43F8-813A-E49688D05771@apple.com>
	 <20080306135139.GA5236@dspnet.fr.eu.org>
	 <b609cb3b0803060737xa0c3c0byb51d51af797eb81f@mail.gmail.com>
	 <6dc9ffc80803060743h502fc96bj6117ef87a8555c3a@mail.gmail.com>
	 <47D012B4.3020104@zytor.com>
	 <20080306162353.GF24887@devserv.devel.redhat.com>
	 <6dc9ffc80803060858i7d4e8b56o99ff8ad301a5cc1a@mail.gmail.com>
	 <47D024AA.9010300@zytor.com>
	 <6dc9ffc80803060914x187049a2hb24ef501baf55601@mail.gmail.com>
	 <47D0271F.4070705@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2008 at 9:17 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> H.J. Lu wrote:
>  >>
>  >>  Not a fix, an (optional) workaround for a system bug.
>  >
>  > So that is the bug in the Linux kernel. Since fixing kernel is much easier
>  > than providing a workaround in compilers, I think kernel should be fixed
>  > and no need for icc/gcc fix.
>  >
>
>  The problem is, you're going to have to be able to produce binaries
>  compatible with old kernels for a *long* time for come.  Are you
>  honestly saying you'll tell those people "use gcc 4.2 or earlier"?  If
>  so, I think most distros will have to freeze gcc for the next several years.
>

Icc has been following psABI for years on Linux and it doesn't stop people
using icc on Linux.  On the other hand, it may be a good idea to provide a
workaround in gcc and enables it by default.  OSVs can fix thekernel and
disable it by default.

We can even issue a message whenever the workaround is used.

H.J.
