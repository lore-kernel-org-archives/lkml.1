Return-Path: <linux-kernel-owner+w=401wt.eu-S1755018AbYAOOEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbYAOOEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 09:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbYAOOEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 09:04:13 -0500
Received: from hpsmtp-eml20.KPNXCHANGE.COM ([213.75.38.85]:47927 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801AbYAOOEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 09:04:12 -0500
From: Frans Pop <elendil@planet.nl>
To: David Miller <davem@davemloft.net>
Subject: Re: [REGRESSION] 2.6.24-rc7: e1000: Detected Tx Unit Hang
Date: Tue, 15 Jan 2008 15:04:09 +0100
User-Agent: KMail/1.9.7
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200801150625.10823.elendil@planet.nl> <20080114.215317.38045859.davem@davemloft.net>
In-Reply-To: <20080114.215317.38045859.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801151504.10047.elendil@planet.nl>
X-OriginalArrivalTime: 15 Jan 2008 14:04:10.0183 (UTC) FILETIME=[801BD570:01C8577F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 January 2008, David Miller wrote:
> From: Frans Pop <elendil@planet.nl>
> > kernel: e1000: eth0: e1000_clean_tx_irq: Detected Tx Unit Hang
>
> Does this make the problem go away?

Yes, it very much looks like that solves it.
I ran with the patch for 6 hours or so without any errors. I then switched 
back to an unpatched kernel and they reappeared immediately.

> (Note this isn't the final correct patch we should apply.  There
>  is no reason why this revert back to the older ->poll() logic
>  here should have any effect on the TX hang triggering...)

s/no reason/no obvious reason/ ? ;-)

Cheers,
FJP
