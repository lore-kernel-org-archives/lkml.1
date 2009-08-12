Return-Path: <linux-kernel-owner+w=401wt.eu-S1752285AbZHLAzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbZHLAzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 20:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbZHLAzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 20:55:35 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57968 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbZHLAze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 20:55:34 -0400
Date: Wed, 12 Aug 2009 01:55:32 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Tippett, Matthew" <Matthew.Tippett@amd.com>
Cc: "Langsdorf, Mark" <mark.langsdorf@amd.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Li, Samuel" <Samuel.Li@amd.com>
Subject: Re: [PATCH][ACPI] AC/DC notifier
Message-ID: <20090812005532.GA31003@srcf.ucam.org>
References: <FFAE0590FF35E441901B67BD8BA62E950245ABD9@storexmb3.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FFAE0590FF35E441901B67BD8BA62E950245ABD9@storexmb3.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 08:51:49PM -0400, Tippett, Matthew wrote:

>    From a graphics perspective (your area of expertise), this will allow KMS
>    drivers to do some more intelligent actions based on the ac/dc state. 
>    Some examples of this could be improving the power consumption of the
>    graphics hardware through adapting clock memory/engine settings for
>    reduced power consumption, reducing refresh rate of the display to reduce
>    scanout memory access, adjusting backlight brightness, etc.

Right. As you say, my concern is that most of this should belong in 
userspace. Where we risk hardware damage there's an obvious argument for 
doing this in kernel, but we should ensure that that's limited to 
whatever coarse-grain handling is absolutely required rather than doing 
things like touching display brightness.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
