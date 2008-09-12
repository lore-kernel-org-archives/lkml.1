Return-Path: <linux-kernel-owner+w=401wt.eu-S1757958AbYILWtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbYILWtr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 18:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755952AbYILWti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 18:49:38 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:34112 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbYILWth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 18:49:37 -0400
Message-ID: <48CAF2B1.7000008@keyaccess.nl>
Date: Sat, 13 Sep 2008 00:52:33 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Frans Pop <elendil@planet.nl>
Subject: Re: [Bug #11550] pnp: Huge number of "io resource overlap" messages
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik> <SpS7rta8n4.A.aHG.2bsyIB@albercik>
In-Reply-To: <SpS7rta8n4.A.aHG.2bsyIB@albercik>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-09-08 21:06, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11550
> Subject		: pnp: Huge number of "io resource overlap" messages
> Submitter	: Frans Pop <elendil@planet.nl>
> Date		: 2008-09-09 10:50 (4 days old)
> References	: http://marc.info/?l=linux-kernel&m=122095745403793&w=4
> Handled-By	: Rene Herman <rene.herman@keyaccess.nl>
> 		  Bjorn Helgaas <bjorn.helgaas@hp.com>
> Patch		: http://marc.info/?l=linux-kernel&m=122098498125536&w=4

It should be. The patch listed should be good as far as I'm concerned 
but needs to be pushed by Bjorn as PnP mainatainer. Generally speaking 0 
wouldn't be a _very_ necesarily invalid value it seems so it's maybe not 
very nice.

If someone wants a changelog though, this should do:

===
PNP: avoid checking unitialized BARs for conflicts

Avoid checking a PCI BAR for conflicts if the BIOS left it unitialized.

Reported-by: Frans Pop <elendil@planet.nl>
Signed-off-by: Rene Herman <rene.herman@gmail.com>
===

(Frans: Tested-by?)

Rene.
