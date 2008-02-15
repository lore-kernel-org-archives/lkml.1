Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbYBOPzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbYBOPzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 10:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbYBOPy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 10:54:59 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:60331 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbYBOPy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 10:54:58 -0500
Date: Fri, 15 Feb 2008 08:54:56 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] gdth: convert to PCI hotplug API
Message-ID: <20080215155456.GE7657@parisc-linux.org>
References: <20080212234928.GA13892@havoc.gtf.org> <1203024822.3158.29.camel@localhost.localdomain> <47B5B374.2080403@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B5B374.2080403@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 10:44:52AM -0500, Jeff Garzik wrote:
> I kept those array for one reason:  you need it to preserve the existing 
> in-driver PCI device sort.

Just get rid of it.  I got rid of it for sym2 during 2.5 and very few
people have complained.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
