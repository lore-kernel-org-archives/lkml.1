Return-Path: <linux-kernel-owner+w=401wt.eu-S1761286AbZCaPJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761286AbZCaPJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755957AbZCaPJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:09:06 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:49588 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbZCaPJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:09:05 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 1/2] kaweth: Fix locking to be SMP-safe
Date: Tue, 31 Mar 2009 17:13:04 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.29-9-default; KDE/4.1.3; x86_64; ; )
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <49d00512.XAF19LdpY1dlK6+U%Larry.Finger@lwfinger.net> <200903310939.09690.oliver@neukum.org> <49D22EFC.1020709@lwfinger.net>
In-Reply-To: <49D22EFC.1020709@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903311713.05451.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 31 März 2009 16:55:56 schrieb Larry Finger:
> Oliver Neukum wrote:
> > Very good.
> >
> >> (X server over the network), the interface stalled with no logged
> >> messages.
> >
> > Do you get something with sysrq-t ?
>
> No. The rest of the system was still functioning; however, the driver
> needed to be unloaded and reloaded before continuing. There were no log
> entries until the driver was unloaded.

This sounds like kaweth_tx_timeout() should have been called.
Did you enable enough logging to see
dev_warn(&net->dev, "%s: Tx timed out. Resetting.\n", net->name);

	Regards
		Oliver

