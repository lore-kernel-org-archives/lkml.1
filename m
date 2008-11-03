Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbYKCOS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbYKCOS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 09:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbYKCOSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 09:18:45 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:55349 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184AbYKCOSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 09:18:44 -0500
Date: Mon, 3 Nov 2008 14:18:36 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: eeepc-laptop rfkill, stupid question #4
Message-ID: <20081103141836.GA31894@srcf.ucam.org>
References: <490B3BB5.8060801@tuffmail.co.uk> <20081031171126.GA17313@srcf.ucam.org> <490B4014.4040009@tuffmail.co.uk> <490B70A3.8010108@tuffmail.co.uk> <20081102040008.GB29606@khazad-dum.debian.net> <490D8C4E.3010201@tuffmail.co.uk> <20081102130655.GA12766@srcf.ucam.org> <20081103141628.GB31078@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103141628.GB31078@khazad-dum.debian.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 12:16:28PM -0200, Henrique de Moraes Holschuh wrote:

> Can you read the state?  If so, you need to unconditionally do so on resume
> (from sleep or hibernation) and rfkill_force_state() it.

The rfkill core actually forces the state on resume, so I think we're 
fine.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
