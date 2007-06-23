Return-Path: <linux-kernel-owner+w=401wt.eu-S1759546AbXFWOkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbXFWOkj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 10:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756350AbXFWOkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 10:40:33 -0400
Received: from bay0-omc2-s15.bay0.hotmail.com ([65.54.246.151]:54902 "EHLO
	bay0-omc2-s15.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755521AbXFWOkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 10:40:32 -0400
X-Originating-IP: [65.93.40.159]
X-Originating-Email: [seanlkml@sympatico.ca]
Date: Sat, 23 Jun 2007 10:38:34 -0400
From: Sean <seanlkml@sympatico.ca>
To: Andi Kleen <ak@suse.de>
Cc: Arkadiusz Miskiewicz <arekm@maven.pl>, Oleg Verych <olecom@flower.upol.cz>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: NAK (bashizm in the /bin/sh script): [PATCH v3]
 doc/oops-tracing: add Code: decode info
Message-Id: <20070623103834.b0f530d8.seanlkml@sympatico.ca>
In-Reply-To: <200706231517.28085.ak@suse.de>
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com>
	<200706231300.22197.ak@suse.de>
	<200706231309.49701.arekm@maven.pl>
	<200706231517.28085.ak@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jun 2007 14:39:34.0904 (UTC) FILETIME=[51720780:01C7B5A4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 15:17:27 +0200
Andi Kleen <ak@suse.de> wrote:

> In this case it's not good enough. We're not writing POSIX portable software 
> here, but Linux software where /bin/sh is /bin/bash. Similar to the Linux 
> kernel which is not written in portable ISO C.

There's no rule that says /bin/sh is always /bin/bash.  What Novell
distributions do does not translate to all of "Linux".  If you are writing
scripts that rely on bash then "#!/bin/bash" is the appropriate way to
document that and give it the best chance of working portably.

Sean
