Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbYHTB3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbYHTB3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 21:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbYHTB2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 21:28:52 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53850 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbYHTB2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 21:28:51 -0400
Date: Wed, 20 Aug 2008 02:28:46 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Andrew Morton <akpm@linux-foundation.org>, corentincj@iksaif.net,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 2/2] eeepc-laptop: Use standard interfaces
Message-ID: <20080820012846.GA7467@srcf.ucam.org>
References: <20080804170833.GA9513@srcf.ucam.org> <20080806092352.GA17801@srcf.ucam.org> <20080806092523.GB17801@srcf.ucam.org> <20080819025815.b5ec1a4c.akpm@linux-foundation.org> <20080819111320.GA19223@srcf.ucam.org> <20080819230950.GC29336@khazad-dum.debian.net> <20080819232411.GA5421@srcf.ucam.org> <20080820011828.GD29336@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080820011828.GD29336@khazad-dum.debian.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 10:18:29PM -0300, Henrique de Moraes Holschuh wrote:

> 1. If the event has no bearing on compulsory hardware state changes (i.e.
> the hardware won't change state by itself when the event happens, it is
> really just reporting a simple key press that will do nothing by itself),
> you just report the key as an event.

Yes. That's all I do.

> 2. If the hardware/firmware *ALSO* compulsory changes the rfkill state (i.e.
> the event also means the real rfkill controller state probably changed), you
> take the opportunity to do a forced immediate state poll and
> rfkill_force_state() the new state.

The firmware does not perform any compulsory change.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
