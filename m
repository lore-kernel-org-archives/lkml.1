Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbXHSNHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbXHSNHQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 09:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbXHSNHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 09:07:04 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50806 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbXHSNHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 09:07:02 -0400
Date: Sun, 19 Aug 2007 15:07:01 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Paolo Ornati <ornati@fastwebnet.it>
cc: Benny Amorsen <benny+usenet@amorsen.dk>, linux-kernel@vger.kernel.org
Subject: Re: variable length argument support (was: [OT] Re: The vi editor
 causes brain damage)
In-Reply-To: <20070819143956.5d21aa7d@localhost>
Message-ID: <Pine.LNX.4.64.0708191505170.6042@fbirervta.pbzchgretzou.qr>
References: <964583.28477.qm@web52504.mail.re2.yahoo.com> <46C7EE0A.2030601@gmail.com>
 <20070819072135.GQ6002@1wt.eu> <m37inr1zae.fsf@ursa.amorsen.dk>
 <20070819143956.5d21aa7d@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 19 2007 14:39, Paolo Ornati wrote:
>> WT> Under unix, the shell resolves "*" and passes the 10000 file names
>> WT> to the "rm" command. Now, execve() may fail because 10000 names in
>> WT> arguments can require too much memory. That's why find and xargs
>> WT> were invented!
>> 
>> It would be very handy if the argument memory space was expanded.
>> Many years ago I hit the limit regularly on Solaris, and going to
>> Linux with its comparatively large limit was a joy. Now it happens to
>> me quite often on Linux as well.
>> 
>
>done  :)
>
>commit b6a2fea39318e43fee84fa7b0b90d68bed92d2ba
>Author: Ollie Wild <aaw@google.com>
>Date:   Thu Jul 19 01:48:16 2007 -0700
>
>    mm: variable length argument support
>
>    Remove the arg+env limit of MAX_ARG_PAGES by copying the strings
>    directly from the old mm into the new mm.

Me wonders. Will that make the "checking for maximum length of command line
arguments" from autotools run forever since execve() will not fail anymore?



	Jan
-- 
