Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbXKNRLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbXKNRLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 12:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbXKNRLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 12:11:41 -0500
Received: from mail.gmx.net ([213.165.64.20]:37230 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753552AbXKNRLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 12:11:40 -0500
X-Authenticated: #24128601
X-Provags-ID: V01U2FsdGVkX18A8SQL5owAmfUTw9+MqReRp8YbZHBeY6zSQ1mb9h
	sEoeRlbmbDmrNf
Date: Wed, 14 Nov 2007 18:11:39 +0100
From: Sebastian Kemper <sebastian_ml@gmx.net>
To: Mark Lord <lkml@rtr.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: libata/PATA: GPCMD_SET_STREAMING via SG_IO does nothing
Message-ID: <20071114171139.GA9387@section-eight>
References: <20071113164323.GA5252@section-eight> <20071113212230.77cadecd@the-village.bc.nu> <20071113232859.GA4681@section-eight> <473B219E.5060508@rtr.ca> <473B2541.10409@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473B2541.10409@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark!

On Wed, Nov 14, 2007 at 11:41:37AM -0500, Mark Lord wrote:
> Ahh.. got it.  The host_status returned (not checked by that code) was 7,
> which means "host error".
>
> In this case, that's because the cmd_len is (16), which is too large for 
> ATAPI.
> It needs to be changed to (12) instead.

I don't understand. You seem to use a cmd_len of 16 in hdparm yourself.
And why does it work with the "old" ATA driver and not with libata if
16 is too large for ATAPI in general?

> The code (apart from totally mishandling any kinds of errors) works after 
> that.

Greetings
Sebastian
