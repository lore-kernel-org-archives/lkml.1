Return-Path: <linux-kernel-owner+w=401wt.eu-S1753093AbYKXCuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbYKXCuk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 21:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYKXCub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 21:50:31 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:56490 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbYKXCua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 21:50:30 -0500
Date: Mon, 24 Nov 2008 02:50:27 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: nForce 790i/MCP55: sata-nv or ahci ?
Message-ID: <20081124025027.GB6216@srcf.ucam.org>
References: <20081124013542.16778a41@werewolf.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081124013542.16778a41@werewolf.home>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 01:35:42AM +0100, J.A. Magallón wrote:

> wargo:~> lspci -s 00:0e
> 00:0e.0 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a3)
> 00:0e.1 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a3)
> 00:0e.2 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a3)

Your hardware doesn't claim to be an AHCI device, so the sata_nv driver 
is probably correct.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
