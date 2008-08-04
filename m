Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbYHDRgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbYHDRgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 13:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754626AbYHDRgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 13:36:32 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51882 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbYHDRgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 13:36:31 -0400
Date: Mon, 4 Aug 2008 18:36:27 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: corentincj@iksaif.net, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, hmh@hmh.eng.br
Subject: Re: [PATCH 2/2] eeepc-laptop: Use standard interfaces
Message-ID: <20080804173627.GA10302@srcf.ucam.org>
References: <20080804170833.GA9513@srcf.ucam.org> <20080804171504.GB9513@srcf.ucam.org> <200808041953.38829.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808041953.38829.IvDoorn@gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 07:53:38PM +0200, Ivo van Doorn wrote:
> On Monday 04 August 2008, Matthew Garrett wrote:
> > eeepc-laptop currently only sends key events via ACPI and has 
> > non-standard rfkill control. Add an input device and use the rfkill 
> > infrastructure.
> > 
> > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> Please use the rfkill_force_state() to report state changes,
> that will ensure that the events are immediately send to the
> rfkill layer.

Why does writing to the sysfs file not generate an update implicitly? 
This is purely a software rfkill device, the input hotkey just generates 
KEY_WLAN and needs rfkill-input to handle it.
-- 
Matthew Garrett <mjg59@srcf.ucam.org>
