Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbYEONdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbYEONdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 09:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbYEONc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 09:32:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55975 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757404AbYEONct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 09:32:49 -0400
Date: Thu, 15 May 2008 14:21:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chris Peterson <cpeterso@cpeterso.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of
 IRQF_SAMPLE_RANDOM
Message-ID: <20080515142154.0595e475@core>
In-Reply-To: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com>
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 00:11:10 -0700 (PDT)
Chris Peterson <cpeterso@cpeterso.com> wrote:

> 
> I know Jeff Garzik says he's not interested in an anti-entropy pogrom for existing net drivers, but here is the patch if anyone else is interested..? :)
> 
> Only 12 net drivers are affected, the last of the theoretically-exploitable network entropy.

Looks fine to me. If Jeff doesn't want to touch them then send them
direct to Andrew/Linus.

A more interesting alternative might be to mark things like network
drivers with a new flag say IRQF_SAMPLE_DUBIOUS so that users can be
given a switch to enable/disable their use depending upon the environment.

Alan
