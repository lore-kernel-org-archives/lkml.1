Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbYJ2S7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbYJ2S7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 14:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbYJ2S73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 14:59:29 -0400
Received: from smtp2.sensus.se ([193.13.139.17]:35052 "EHLO smtp2.sensus.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004AbYJ2S72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 14:59:28 -0400
Date: Wed, 29 Oct 2008 19:58:56 +0100
From: Oskar Liljeblad <oskar@osk.mine.nu>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sata errors with Seagate 1.5TB on AMD 780G/SB700 motherboard
Message-ID: <20081029185856.GA8152@osk.mine.nu>
References: <fa.01zEaARwrup2dCOTuHTYxzuS9BI@ifi.uio.no> <49079E09.20703@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49079E09.20703@shaw.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -96.0 (---------------------------------------------------)
X-Spam-Report: Spam detection software, running on the system "smtp2.sensus.se", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  On Tuesday, October 28, 2008 at 17:37, Robert Hancock
	wrote: [..] >> Hard drives (ata1/sda, ata2/sdb, ata3/sdc): Seagate
	ST31500341AS 1.5TB SATA [..] >> 19:24:26 ata2: exception Emask 0x50 SAct
	0x0 SErr 0x90a02 action 0xe frozen >> 19:24:26 ata2: irq_stat
	0x00400000, PHY RDY changed >> 19:24:26 ata2: SError: { RecovComm
	Persist HostInt PHYRdyChg 10B8B } [..] > Sounds like the drive and the
	controller are unhappy with each other, or > there's some kind of
	communications or hardware problem. Not likely a > kernel issue. > >
	It's unclear if limiting to 1.5 Gbps would help, you could try it and
	see.. [...] 
	Content analysis details:   (-96.0 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-100 USER_IN_WHITELIST      From: address is in the user's white-list
	2.0 RCVD_IN_SORBS_DUL      RBL: SORBS: sent directly from dynamic IP address
	[81.236.171.23 listed in dnsbl.sorbs.net]
	2.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 28, 2008 at 17:37, Robert Hancock wrote:
[..]
>> Hard drives (ata1/sda, ata2/sdb, ata3/sdc): Seagate ST31500341AS 1.5TB SATA
[..]
>> 19:24:26 ata2: exception Emask 0x50 SAct 0x0 SErr 0x90a02 action 0xe frozen
>> 19:24:26 ata2: irq_stat 0x00400000, PHY RDY changed
>> 19:24:26 ata2: SError: { RecovComm Persist HostInt PHYRdyChg 10B8B }
[..]
> Sounds like the drive and the controller are unhappy with each other, or  
> there's some kind of communications or hardware problem. Not likely a  
> kernel issue.
>
> It's unclear if limiting to 1.5 Gbps would help, you could try it and see..

It seems the solution is to disable write caching. So far no errors, and
other people confirm this solution.

Anyway Seagate (inofficially) claims it's a driver issue in Linux - from
http://forums.seagate.com/stx/board/message?board.id=ata_drives&thread.id=2390&view=by_date_ascending&page=6

  "We already know about the Linux issue, it is indeed a kernel error
  causing the problem as it was explained to me by one of our developers."

Regards,

Oskar
