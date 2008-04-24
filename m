Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbYDXGP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbYDXGP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 02:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYDXGPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 02:15:33 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:16163 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752848AbYDXGPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 02:15:32 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-5.tower-29.messagelabs.com!1209017730!10245763!3
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Thu, 24 Apr 2008 08:12:56 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Roel Kluin <12o3l@tiscali.nl>
CC: <ben-linux@fluff.org>, Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial: s3c2410: platform_get_irq() may return signed unnoticed
Message-ID: <20080424061256.GD17978@digi.com>
References: <480FB148.5000704@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <480FB148.5000704@tiscali.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 24 Apr 2008 06:12:57.0092 (UTC) FILETIME=[3D578440:01C8A5D2]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.500.1026-15866.007
X-TM-AS-Result: No--3.895000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> dev->irq is unsigned, platform_get_irq() may return signed unnoticed
This must read "port->irq is unsigned", apart from that it looks fine.

Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
