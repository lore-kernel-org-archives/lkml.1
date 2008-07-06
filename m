Return-Path: <linux-kernel-owner+w=401wt.eu-S1759633AbYGFXBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759633AbYGFXBi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 19:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756588AbYGFXB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 19:01:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbYGFXB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 19:01:28 -0400
Date: Sun, 6 Jul 2008 19:01:18 -0400
From: Alan Cox <alan@redhat.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, alan@redhat.com,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: pata_it821x completely broken
Message-ID: <20080706230118.GA25905@devserv.devel.redhat.com>
References: <200807042153.56644.linux@rainbow-software.org> <200807051242.00545.linux@rainbow-software.org> <20080706203716.2c5bdcc5@lxorguk.ukuu.org.uk> <200807062350.35650.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807062350.35650.linux@rainbow-software.org>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2008 at 11:50:33PM +0200, Ondrej Zary wrote:
> Thanks, it does not complain about HPA anymore. However, there are some error 
> messages left. I thought that they were connected with the HPA, but obviously 
> they aren't:

FLUSH_CACHE .. I would hope the firmware supports that if advertised. If so
then adding it to the switch in it821x_smart_qc_issue might do the trick
(ATA_CMD_FLUSH and ATA_CMD_FLUSH_EXT). I'd be interested to know if your
firmware seems to support that or whether the entire thing goes castors up
if it gets through.

Alan
