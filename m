Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbZKRALq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbZKRALq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 19:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbZKRALp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 19:11:45 -0500
Received: from thunk.org ([69.25.196.29]:44070 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206AbZKRALo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 19:11:44 -0500
Date: Tue, 17 Nov 2009 19:11:42 -0500
From: tytso@mit.edu
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Frank Mayhar <fmayhar@google.com>, Holger Freyther <zecke@selfish.org>
Subject: Re: [Bug #14354] Bad corruption with 2.6.32-rc1 and upwards
Message-ID: <20091118001142.GA3816@thunk.org>
Mail-Followup-To: tytso@mit.edu, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Frank Mayhar <fmayhar@google.com>,
	Holger Freyther <zecke@selfish.org>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
 <xXQGFmujPl.A.6w.YUdALB@chimera>
 <20091117020202.GA23066@mit.edu>
 <200911172323.11224.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911172323.11224.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 11:23:11PM +0100, Rafael J. Wysocki wrote:
> 
> I wasn't quite sure what the status was, because there was some
> activity in the bug entry after it had been marked as resolved.

Yeah, the actual regression had been resolved (by changing the
default), but the root cause was due to the fact that not enough
people had done proper power-fail testing for the journal_checksum,
even though the code had been in the kernel for a very long time.  The
discussion afterwards was focused around fixing those problems so we
could make journal_checksum be the default at some point in the future.

      	   		       	   	      - Ted
