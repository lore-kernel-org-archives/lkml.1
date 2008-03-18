Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbYCRNdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbYCRNdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 09:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbYCRNc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 09:32:57 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2424 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbYCRNcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 09:32:55 -0400
Date: Tue, 18 Mar 2008 13:31:10 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, stern@rowland.harvard.edu,
       lenb@kernel.org, greg@kroah.com, akpm@linux-foundation.org, rjw@sisk.pl
Subject: Re: [Build Failure] linux-next: Tree for March 18
Message-ID: <20080318132550.GB30500@shadowen.org>
References: <20080318205259.13726d23.sfr@canb.auug.org.au> <47DFA49D.4000007@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DFA49D.4000007@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2008 at 04:46:45PM +0530, Kamalesh Babulal wrote:
> Hi Stephen,
> 
> The kernel build of linux-next tree(s) have been failing from 20080314 with
> the build failure
> 
> drivers/serial/serial_core.c: In function `uart_add_one_port':
> drivers/serial/serial_core.c:2359: error: invalid lvalue in assignment
> make[2]: *** [drivers/serial/serial_core.o] Error 1
> 
> And the patch was submitted for the same http://marc.info/?l=linux-next&m=120561799422065&w=2

This breakage is shown up when compiled with a config which doesn't have
CONFIG_PM set.  It is a common error to only test with that turned on
and I am sure that this is just one of a number of bugs that have been
picked up by real machine configs.

Perhaps it would be worth having one of your integration test runs be
with a configuration with CONFIG_PM disabled so that they get detected
earlier in the process.

-apw
