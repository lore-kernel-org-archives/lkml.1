Return-Path: <linux-kernel-owner+w=401wt.eu-S1759639AbYAKKIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639AbYAKKIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 05:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755637AbYAKKIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 05:08:48 -0500
Received: from ns.firmix.at ([62.141.48.66]:4510 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755157AbYAKKIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 05:08:47 -0500
Subject: Re: [PATCH] checkpatch.pl: allow piping
From: Bernd Petrovitsch <bernd@firmix.at>
To: Daniel Walker <dwalker@mvista.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, apw@shadowen.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
       jschopp@austin.ibm.com
In-Reply-To: <1200043827.29897.70.camel@imap.mvista.com>
References: <20080111041120.085610726@mvista.com>
	 <47872E35.3070705@gmail.com> <1200043035.29897.62.camel@imap.mvista.com>
	 <47873505.7040008@gmail.com>  <1200043399.3905.9.camel@gimli.at.home>
	 <1200043827.29897.70.camel@imap.mvista.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Fri, 11 Jan 2008 11:08:38 +0100
Message-Id: <1200046118.10166.5.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.334 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.334 required=5
X-Spam-Score: -2.334 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fre, 2008-01-11 at 01:30 -0800, Daniel Walker wrote:
> On Fri, 2008-01-11 at 10:23 +0100, Bernd Petrovitsch wrote:
> > On Fre, 2008-01-11 at 10:21 +0100, Jiri Slaby wrote:
> > > On 01/11/2008 10:17 AM, Daniel Walker wrote:
> > > > On Fri, 2008-01-11 at 09:52 +0100, Jiri Slaby wrote:
> > > >> On 01/11/2008 05:10 AM, Daniel Walker wrote:
[...]
> > > > I was using it to do something like the following ,
> > > > 
> > > > git show 9914cad54c79d0b89b1f066c0894f00e1344131c
> > | ./scripts/checkpatch.pl
> > > 
> > > Ok, and if you add a - there, it should have the same effect, but
> > for free, 
> > > doesn't it:
> > > git show 9914cad54c79d0b89b1f066c0894f00e1344131c
> > | ./scripts/checkpatch.pl -
> > 
> > JftSoC:
> > git show 9914cad54c79d0b89b1f066c0894f00e1344131c
> > | ./scripts/checkpatch.pl /dev/stdin
> > (and there a a few others) should also do the trick.
> 
> Not a particularly attractive command line .. Might still be a good idea

Might be.
But it works for (almost?) all programs (which do not need seekable
input) which absolutely want the input file specified by a parameter.
And if it's an proprietary program, you can't even patch it.

> to add this since these two forms alluded me, and are likely to allude
> people new to unix all together (who is more likely to be using this
> particular tool)..

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


