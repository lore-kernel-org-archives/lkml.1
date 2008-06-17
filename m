Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbYFQLOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbYFQLOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 07:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbYFQLN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 07:13:57 -0400
Received: from mout.perfora.net ([74.208.4.194]:50116 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbYFQLN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 07:13:57 -0400
Date: Tue, 17 Jun 2008 06:03:07 -0500 (CDT)
From: "R.L. Horn" <lists@eastcheap.org>
X-X-Sender: rlhorn@hani.compact.internal
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: serial problem (minicom)
In-Reply-To: <20080617095827.0f4f77de@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LNX.1.00.0806170559280.13421@hani.compact.internal>
References: <alpine.LNX.1.00.0806131635260.1294@hani.compact.internal> <20080614102900.6830ed46@lxorguk.ukuu.org.uk> <alpine.LNX.1.00.0806150032050.1283@hani.compact.internal> <20080616111329.3ae97879@lxorguk.ukuu.org.uk> <alpine.LNX.1.00.0806162306400.10919@hani.compact.internal>
 <20080617095827.0f4f77de@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Provags-ID: V01U2FsdGVkX1/PXM3+NhEfZ3vEhcr0NEOR0bvUU67B4XYjApI
 B+ASFaumCAi/R3NWk9LJTCN7f/DJshD9lc8YVqkuwjduThOu3C
 vCfk/LmTSKDxTD4fsqKEw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2008, Alan Cox wrote:

> Ah ok I know what the bug is - it was fixed in 2.6.26-rc as follows
>
> +       /* Don't rewrite B0 */
> +       if (tty_termios_baud_rate(termios))
> +               tty_termios_encode_baud_rate(termios, baud, baud);
> }

Oh.

Oh well.

I guess I'll just fix it here and wait for the official fix.
