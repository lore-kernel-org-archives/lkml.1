Return-Path: <linux-kernel-owner+w=401wt.eu-S1763496AbZCaSqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763496AbZCaSqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 14:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762816AbZCaSlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 14:41:49 -0400
Received: from fmailhost05.isp.att.net ([207.115.11.55]:57847 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762461AbZCaSlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 14:41:44 -0400
X-Originating-IP: [69.76.240.125]
Message-ID: <49D263B7.4000409@lwfinger.net>
Date: Tue, 31 Mar 2009 13:40:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: jgarzik@pobox.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] kaweth: Fix locking to be SMP-safe
References: <49d00512.XAF19LdpY1dlK6+U%Larry.Finger@lwfinger.net> <200903310939.09690.oliver@neukum.org> <49D22EFC.1020709@lwfinger.net> <200903311713.05451.oliver@neukum.org>
In-Reply-To: <200903311713.05451.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> 
> This sounds like kaweth_tx_timeout() should have been called.
> Did you enable enough logging to see
> dev_warn(&net->dev, "%s: Tx timed out. Resetting.\n", net->name);


The problem turned out to be an old, slow router that was locking, and not a
problem with kaweth. I'll resubmit my patches.

Larry
