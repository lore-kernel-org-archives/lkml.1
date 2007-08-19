Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbXHSMk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbXHSMk3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 08:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbXHSMkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 08:40:21 -0400
Received: from aa013msr.fastwebnet.it ([85.18.95.73]:34909 "EHLO
	aa013msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbXHSMkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 08:40:20 -0400
Date: Sun, 19 Aug 2007 14:39:56 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Benny Amorsen <benny+usenet@amorsen.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [OT] Re: The vi editor causes brain damage
Message-ID: <20070819143956.5d21aa7d@localhost>
In-Reply-To: <m37inr1zae.fsf@ursa.amorsen.dk>
References: <964583.28477.qm@web52504.mail.re2.yahoo.com>
	<46C7EE0A.2030601@gmail.com>
	<20070819072135.GQ6002@1wt.eu>
	<m37inr1zae.fsf@ursa.amorsen.dk>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Aug 2007 14:31:21 +0200
Benny Amorsen <benny+usenet@amorsen.dk> wrote:

> >>>>> "WT" == Willy Tarreau <w@1wt.eu> writes:
> 
> WT> Under unix, the shell resolves "*" and passes the 10000 file names
> WT> to the "rm" command. Now, execve() may fail because 10000 names in
> WT> arguments can require too much memory. That's why find and xargs
> WT> were invented!
> 
> It would be very handy if the argument memory space was expanded.
> Many years ago I hit the limit regularly on Solaris, and going to
> Linux with its comparatively large limit was a joy. Now it happens to
> me quite often on Linux as well.
> 

done  :)

commit b6a2fea39318e43fee84fa7b0b90d68bed92d2ba
Author: Ollie Wild <aaw@google.com>
Date:   Thu Jul 19 01:48:16 2007 -0700

    mm: variable length argument support

    Remove the arg+env limit of MAX_ARG_PAGES by copying the strings
    directly from the old mm into the new mm.

-- 
	Paolo Ornati
	Linux 2.6.23-rc3-g2a677896 on x86_64
