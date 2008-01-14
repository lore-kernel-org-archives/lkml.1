Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbYANR3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbYANR3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 12:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbYANR3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 12:29:45 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:3328 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbYANR3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 12:29:45 -0500
Date: Mon, 14 Jan 2008 17:30:32 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch: add filename before the summary line
Message-ID: <20080114173032.GE19327@shadowen.org>
References: <20080113233405.5fcdaff5@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080113233405.5fcdaff5@paolo-desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2008 at 11:34:05PM +0100, Paolo Ciarrocchi wrote:
> With the patch applied the output of checkpatch.pl is as follow:
> ./arch/arm/mach-footbridge/ebsa285-pci.c 
> total: 1 errors, 0 warnings, 48 lines checked
> 
> Adding the file name allowed me to collects stats running:
> 	find . -name *.c |xargs ./scripts/checkpatch.pl --file |grep -B 1 total
> but I though it might me useful for other purposes to add the file name
> after the list of errors and warnings and before the summary,
> when the list is long I find handy to print out the filename as a reminder.

Hmmm, that being unconfitional would probabally break a raft of other
users.  Also would it be more useful to put it on the front of the
summary line?  So that if you have a bunch of files to check then you
get something more like:

foo: total: 1 errors, ...
bar: total: 0 errors, ...

-apw
