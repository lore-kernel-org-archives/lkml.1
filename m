Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbXEMCHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbXEMCHQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 22:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbXEMCHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 22:07:05 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:50468 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421AbXEMCHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 22:07:04 -0400
Date: Sat, 12 May 2007 20:06:53 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] Workaround for a PCI restoring bug
In-reply-to: <fa.K6U9hglycxHd65x5b6pmUzJjdoA@ifi.uio.no>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org
Message-id: <464672BD.7010507@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.K6U9hglycxHd65x5b6pmUzJjdoA@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek wrote:
> Hello,
> 
> as of 2.6.21-git16, the bugs related to restoring PCI are still present. The
> save pci function reads only -1 from the PCI config space and when restoring,
> it messes up totaly most PCI devices. The attached patch is workaround only
> until proper fix is found and included. Could it be included into the mainline
> for now?

It's not really a fix, that value might be legitimately supposed to be 
in the config space. Sounds like some driver is disabling the device 
before saving the state or something..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

