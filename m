Return-Path: <linux-kernel-owner+w=401wt.eu-S1757032AbYCFReW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032AbYCFReW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 12:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbYCFReO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 12:34:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41127 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYCFReO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 12:34:14 -0500
Message-ID: <47D02780.4060309@zytor.com>
Date: Thu, 06 Mar 2008 09:18:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Robert Dewar <dewar@adacore.com>
CC: NightStrike <nightstrike@gmail.com>, Olivier Galibert <galibert@pobox.com>,
       Chris Lattner <clattner@apple.com>, Michael Matz <matz@suse.de>,
       Richard Guenther <richard.guenther@gmail.com>,
       Joe Buck <Joe.Buck@synopsys.com>, Jan Hubicka <hubicka@ucw.cz>,
       Aurelien Jarno <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction
 flag
References: <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de> 	 <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com> 	 <47CF11D6.7070901@zytor.com> 	 <738B72DB-A1D6-43F8-813A-E49688D05771@apple.com> 	 <Pine.LNX.4.64.0803052258530.20583@wotan.suse.de> 	 <2F47E21A-9055-4EC3-99CF-B666BBC045C3@apple.com> 	 <47CF3F09.4080606@zytor.com> 	 <578FCA7D-D7A6-44F6-9310-4A97C13CDCBE@apple.com> 	 <47CF44E7.3020106@zytor.com> <20080306135139.GA5236@dspnet.fr.eu.org> <b609cb3b0803060737xa0c3c0byb51d51af797eb81f@mail.gmail.com> <47D01457.30001@adacore.com>
In-Reply-To: <47D01457.30001@adacore.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Dewar wrote:
> 
> Sounds good, but has almost nothing to do with the real world. I 
> remember back in Realia COBOL days, we had to carefully copy IBM
> bugs in the IBM mainframe COBOL compiler. Doing things right and
> fixing the bug would have been the right thing to do, but no one
> would have used Realia COBOL :-)
> 
> Another story, the sad story of the intel chip (I think it was
> the 80188) where Intel made use of Int 5, which was documented
> as reserved. Unfortunately, Microsoft/IBM had used this for
> print screen or some such. Intel was absolutely right that
> their documentation was clear and it was wrong to have used
> these interrupts .. but the result was a warehouse of unused
> chips.

IBM used it for print screen (and other calls), because Microsoft 
cassette BASIC used all the non-reserved INT instructions as byte codes 
(they cut it down to *only* half the interrupt vectors in the disk version.)

We're still stuck with the consequences of that hack.

	-hpa
