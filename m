Return-Path: <linux-kernel-owner+w=401wt.eu-S1762614AbYDVJc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762614AbYDVJc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 05:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757148AbYDVJcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 05:32:19 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:22203 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756637AbYDVJcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 05:32:18 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-15.tower-29.messagelabs.com!1208856737!11690420!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Tue, 22 Apr 2008 11:32:13 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Ben Nizette <bn@niasdigital.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: UIO: Implement a UIO interface for the SMX Cryptengine
Message-ID: <20080422093213.GA27126@digi.com>
References: <20080414100848.GA19369@digi.com> <1208173181.3351.63.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1208173181.3351.63.camel@moss.renham>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 22 Apr 2008 09:32:14.0230 (UTC) FILETIME=[BF867B60:01C8A45B]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.500.1026-15864.006
X-TM-AS-Result: No--16.243700-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Ben Nizette wrote:
> 
> [putting lkml back in CC]
> 
> On Mon, 2008-04-14 at 12:08 +0200, Uwe Kleine-König wrote:
> 
> > The line "depends on UIO" isn't needed (anymore) because the whole
> > config item is located in a "if UIO"/"endif".
> 
> Right, just saw your patch fly by.  Given mine's been taken up by gregkh
> already I was kinda hoping someone further up the tree would end up
> fixing it.  If not I can of course rebase and resend.
Your patch is in Linus' tree in the meantime and mine is not (yet).  I
suggest to prepare a patch such that both drivers share some code after
my driver has hit mainline.
 
> > The "default n" isn't necessary because that's the default anyhow.
> 
> Eh, I like to be explicit.
I expect this to be cleaned up later by someone à la:

	git log -E --grep='([Rr]emove|useless|unnecessary).*default n\>'

:-)

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
