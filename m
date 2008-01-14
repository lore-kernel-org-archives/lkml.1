Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbYANTyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbYANTyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbYANTyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:54:22 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:30360 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbYANTyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:54:21 -0500
Subject: Re: [PATCH] checkpatch.pl: show how to read from stdin
From: Daniel Walker <dwalker@mvista.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andy Whitcroft <apw@shadowen.org>, Bernd Petrovitsch <bernd@firmix.at>,
       linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <478BB89A.803@s5r6.in-berlin.de>
References: <47873505.7040008@gmail.com>
	 <1200043399.3905.9.camel@gimli.at.home>
	 <1200043827.29897.70.camel@imap.mvista.com> <47873833.30001@gmail.com>
	 <1200044206.29897.73.camel@imap.mvista.com>
	 <4787502B.2020606@s5r6.in-berlin.de> <47875809.7060301@gmail.com>
	 <tkrat.b5ac0cacd128569b@s5r6.in-berlin.de>
	 <20080114171736.GC19327@shadowen.org>
	 <1200332116.31521.3.camel@imap.mvista.com>
	 <20080114191243.GB25058@shadowen.org>
	 <1200338243.31521.10.camel@imap.mvista.com>
	 <478BB89A.803@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Mon, 14 Jan 2008 11:51:46 -0800
Message-Id: <1200340306.31521.17.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-14 at 20:31 +0100, Stefan Richter wrote:
> AFAIU Daniel's patch still leaves the possibility to use the '-'
> syntax,
> doesn't it?
> 
> (The program 'cat' is of the kind which always reads from stdin if no
> file name is given, or if '-' is given instead of a file name.  So,
> 'cat' allows Andy to start it and then type something in for cat to
> process in either case, while checkpatch supports this only with '-'
> as
> argument.  OTOH it's easier to get checkpatch to print a usage note
> than
> it is with cat.  There you have to type no less than 'cat --help', or
> at
> least with GNU cat.)

I tried the following with my changes,

./scripts/checkpatch.pl -
cat | ./scripts/checkpatch.pl

Both allowed pasting patches and pressing Ctrl-D , then it processed the
patch..

and

cat <patchname> | ./scripts/checkpatch.pl

Also processed the patch ..

Daniel

