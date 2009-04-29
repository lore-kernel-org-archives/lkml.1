Return-Path: <linux-kernel-owner+w=401wt.eu-S1761485AbZD2V3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761485AbZD2V3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 17:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756233AbZD2V3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 17:29:32 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38808 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761275AbZD2V3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 17:29:31 -0400
Date: Wed, 29 Apr 2009 22:29:24 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Add support for more dell-wmi hotkeys
Message-ID: <20090429212924.GA7900@srcf.ucam.org>
References: <49ECBAE2.2080308@dell.com> <49EE09D9.2060209@dell.com> <20090429165729.GB32619@srcf.ucam.org> <49F89981.10806@dell.com> <20090429183154.GC2325@srcf.ucam.org> <49F8C59F.2010603@dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F8C59F.2010603@dell.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 04:24:47PM -0500, Mario Limonciello wrote:

> I've obtained one of these and taken a look at it with a copy of Win 7
> and compared with dell-wmi and my patchset applied.  This platform's WMI
> support was introduced before Win7's WMI spec was drafted, and so it
> doesn't adhere to the spec.  I think the best thing to do will be create
> a DMI table to match for keys that are only on a per system basis for
> anything before this spec was ready.  I don't expect many other
> platforms like this, but it will allow for additional granularity in
> case something in the future ever deviates spec as well.

Ok. Is there any programmatic way to determine whether a given Dell 
complies with your WMI spec or not? I'd prefer not to use DMI tables 
unless it's the only way to identify the machines - the risk is that 
there'll be something else that also uses its own codes and will just 
behave oddly until someone figures out why it's broken.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
