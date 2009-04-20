Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbZDTSs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbZDTSs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 14:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755106AbZDTSsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 14:48:14 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46660 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbZDTSsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 14:48:13 -0400
Date: Mon, 20 Apr 2009 19:48:07 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Add support for Eject hotkey in dell-wmi
Message-ID: <20090420184807.GA3490@srcf.ucam.org>
References: <49ECBAE2.2080308@dell.com> <20090420182312.GA2910@srcf.ucam.org> <49ECBE35.9040003@dell.com> <20090420182848.GA3105@srcf.ucam.org> <49ECC279.2080607@dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49ECC279.2080607@dell.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 01:44:09PM -0500, Mario Limonciello wrote:

>    I've checked with the BIOS teams further, and they indicated at the time
>    that this is enabled on those consumer systems, the hotkey should be
>    switched over to a mechanical key rather than a software key, so the
>    keyboard interface would not see this key.  The support in the BIOS to
>    turn on and off WMI would actually enable SMI hot key events instead
>    (which could then be serviced by dell-laptop).

Ah, ok, that's fine. As long as the event will only be delivered either 
via WMI or the keyboard controller then we should be good.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
