Return-Path: <linux-kernel-owner+w=401wt.eu-S1762196AbYEWFpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762196AbYEWFpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 01:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbYEWFpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 01:45:30 -0400
Received: from mail51.messagelabs.com ([216.82.244.179]:38862 "EHLO
	mail51.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbYEWFp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 01:45:28 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-11.tower-51.messagelabs.com!1211521527!1339976!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Fri, 23 May 2008 07:41:15 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Tom Spink <tspink@gmail.com>
CC: "Hans J. Koch" <hjk@linutronix.de>, <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Jan Altenberg <jan.altenberg@linutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable interrupts
Message-ID: <20080523054115.GB28807@digi.com>
References: <20080522192252.GB3226@local> <20080522192637.GC3226@local> <7b9198260805221247t715660d1l4085fe8c310f89c@mail.gmail.com> <20080522200814.GD3226@local> <7b9198260805221326t6d23b757p2ffe646db70fceba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b9198260805221326t6d23b757p2ffe646db70fceba@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 23 May 2008 05:41:16.0240 (UTC) FILETIME=[9E534500:01C8BC97]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tom,

Tom Spink wrote:
> The added benefit is that the code becomes less complex, as you don't
> have to check buffer sizes and copy the integer from userspace.
AFAIK this is wrong.  You need to copy the integer from userspace in
uio_ioctl.  Actually it's a value coming from user space, so you need to
do it somewhere.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
