Return-Path: <linux-kernel-owner+w=401wt.eu-S1756319AbYFYSIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319AbYFYSIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 14:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYFYSHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 14:07:52 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:44096 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbYFYSHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 14:07:52 -0400
Message-ID: <486289A8.1040702@keyaccess.nl>
Date: Wed, 25 Jun 2008 20:08:40 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Re: regression, 2.6.26-rc7, pnp: quirk_system_pci_resources()
References: <485C6388.1050903@keyaccess.nl> <485D356A.402@keyaccess.nl> <485D86BD.5050803@keyaccess.nl> <200806240917.35773.bjorn.helgaas@hp.com>
In-Reply-To: <200806240917.35773.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24-06-08 17:17, Bjorn Helgaas wrote:

> I think your patch makes sense, and you can add my ack.

Thank you, done. I used pnp_resource_type_name() from your patches...

> I do have the feeling that the reason we need the quirk is because we
> aren't handling those PNP device resources quite correctly in the 
> first place.  But I don't have any good ideas about what's wrong yet.
> 
> My first thought was that those regions might be marked as 
> ACPI_PRODUCER resources (i.e., the PNP device forwards transactions 
> in that region to a downstream device).  In that case, the PNP device
> is really a bridge, and it shouldn't reserve the region (or at least
> should not mark it as busy).  But I think we currently ignore 
> ACPI_PRODUCER resources completely, so I don't see how that could 
> cause this problem.

I'm not up on the ACPI side of things at least, but am available for any 
testing you'd like me to do. Just say the word.

Rene.
