Return-Path: <linux-kernel-owner+w=401wt.eu-S1762047AbYAKRlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762047AbYAKRlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 12:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761423AbYAKRlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 12:41:45 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:51153 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761086AbYAKRlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 12:41:44 -0500
Subject: Re: [PATCH] checkpatch.pl: show how to read from stdin
From: Daniel Walker <dwalker@mvista.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andy Whitcroft <apw@shadowen.org>, Bernd Petrovitsch <bernd@firmix.at>,
       linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <4787A787.2000503@s5r6.in-berlin.de>
References: <20080111041120.085610726@mvista.com>
	 <47872E35.3070705@gmail.com> <1200043035.29897.62.camel@imap.mvista.com>
	 <47873505.7040008@gmail.com>  <1200043399.3905.9.camel@gimli.at.home>
	 <1200043827.29897.70.camel@imap.mvista.com>  <47873833.30001@gmail.com>
	 <1200044206.29897.73.camel@imap.mvista.com>
	 <4787502B.2020606@s5r6.in-berlin.de> <47875809.7060301@gmail.com>
	 <tkrat.b5ac0cacd128569b@s5r6.in-berlin.de>
	 <1200071343.29897.86.camel@imap.mvista.com>
	 <4787A787.2000503@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Fri, 11 Jan 2008 09:39:51 -0800
Message-Id: <1200073192.29897.95.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-11 at 18:29 +0100, Stefan Richter wrote:
> Daniel Walker wrote:
> > On Fri, 2008-01-11 at 18:06 +0100, Stefan Richter wrote:
> >> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> >> +	print "When patchfile is -, read standard input.\n";
> 
> > Naww .. Why add documentation when you can just make it do the right
> > thing ..
> 
> Why add code for a feature which already exists?

To make it simpler to use .. A good percentage (if not all) command line
unix data processing utils accept piped data directly, without the need
for the "-" .. That's the expect usage .. checkpatch.pl doesn't need to
deviate from the norm, there is no size constraint, there is no line
limit .. So we're not duplicating functionality, we're making the tool
conform ..

Daniel

