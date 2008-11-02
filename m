Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbYKBNHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbYKBNHS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 08:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbYKBNHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 08:07:04 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:37336 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbYKBNHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 08:07:03 -0500
Date: Sun, 2 Nov 2008 13:06:55 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: eeepc-laptop rfkill, stupid question #4
Message-ID: <20081102130655.GA12766@srcf.ucam.org>
References: <490B3BB5.8060801@tuffmail.co.uk> <20081031171126.GA17313@srcf.ucam.org> <490B4014.4040009@tuffmail.co.uk> <490B70A3.8010108@tuffmail.co.uk> <20081102040008.GB29606@khazad-dum.debian.net> <490D8C4E.3010201@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490D8C4E.3010201@tuffmail.co.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2008 at 11:17:34AM +0000, Alan Jenkins wrote:

> Did you have any thoughts on the hibernation case? It's possible for the 
> rfkill state to change while hibernated. You can boot into a different 
> OS, or change it in the BIOS setup screen. At present the rfkill core 
> overrides the change on resume.

There are two choices. We can either set the rfkill to the hardware 
state, or we can set the hardware state to the rfkill state. I think 
both are valid choices and I'm happy to implement either of them in the 
resume path. However, as you point out, right now it's possible for the 
user to change the hardware state in the BIOS and cause the two to get 
out of sync. That's certainly not ideal.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
