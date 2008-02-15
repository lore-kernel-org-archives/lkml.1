Return-Path: <linux-kernel-owner+w=401wt.eu-S1764421AbYBOMHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764421AbYBOMHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 07:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbYBOMHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 07:07:36 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:39731 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbYBOMHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 07:07:35 -0500
Date: Fri, 15 Feb 2008 12:07:20 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Message-ID: <20080215120720.GA31578@srcf.ucam.org>
References: <20080214103801.GB4366@ics.muni.cz> <20080214122452.GB12775@khazad-dum.debian.net> <20080215110213.GA5648@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215110213.GA5648@ics.muni.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: 2.6.25-rc1 regression - IBM ACPI backlight
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 12:02:13PM +0100, Lukas Hejtmanek wrote:

> 2.6.24 kernel has two acpi_video[01]. 2.6.25-rc1 does not, it contains only
> acpi_video0 (even in text mode in single user without X being loaded) which
> does not work at all.

Sigh. Ok. Could you attach the output of acpidump and lspci, please? 
I'll try to figure out why this is wrong.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
