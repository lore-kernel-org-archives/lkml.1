Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbZAODAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbZAODAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 22:00:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbZAOC7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 21:59:52 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:51877 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbZAOC7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 21:59:51 -0500
Date: Thu, 15 Jan 2009 02:59:45 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Martin Michlmayr <tbm@cyrius.com>,
       "elendil@planet.nl" <elendil@planet.nl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       fengguang.wu@intel.com
Subject: Re: [2.6.28] Kernel panic after closing lid on HP 2510p
Message-ID: <20090115025945.GA19472@srcf.ucam.org>
References: <200901121356.46236.elendil@planet.nl> <20090113123056.GA2464@deprecation.cyrius.com> <20090114162603.c632d82e.akpm@linux-foundation.org> <20090115020311.GA18740@srcf.ucam.org> <20090114181542.34614acf.akpm@linux-foundation.org> <20090115022106.GA19069@srcf.ucam.org> <1231988103.20746.149.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1231988103.20746.149.camel@rzhang-dt>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 10:55:03AM +0800, Zhang Rui wrote:

> DIDL is an IGD OpRegion field, as the Supported Display Devices ID List.
> ﻿it's evaluated by the _DOD method when ACPI video driver is loaded.
> And according to the spec, "The graphics driver writes to this field
> once during its initialization"
> if DIDL is not empty, a flag is set and the SMI will not be invoked when
> closing the lid.
> In our tests, this field (DIDL) is set in windows when _DOD is invoked
> while it's not in Linux.
> I can workaround this bug by setting the DIDL manually in AML code.

Oh, huh. Yeah, that sounds plausible. I'll give it a go here tomorrow.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
