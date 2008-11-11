Return-Path: <linux-kernel-owner+w=401wt.eu-S1754998AbYKKBeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbYKKBeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 20:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbYKKBeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 20:34:06 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:35887 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbYKKBeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 20:34:04 -0500
Date: Tue, 11 Nov 2008 01:33:59 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: ACPI crash on lid close - SMP race?
Message-ID: <20081111013359.GA11364@srcf.ucam.org>
References: <20081110161105.GA2041@srcf.ucam.org> <1226366834.15014.60.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226366834.15014.60.camel@rzhang-dt>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 09:27:14AM +0800, Zhang Rui wrote:
> well, there is a bug report for this problem:
> http://bugzilla.kernel.org/show_bug.cgi?id=11259

I'll give the noirqbalance case a go.

> and there are some bug reports for a similar problem (system crashes on
> lid close if _DOS=1, but on a UP platform).
> http://bugzilla.kernel.org/show_bug.cgi?id=6001#c49

I think the _DOS=1 case is somewhat different. There you'd expect 
significantly more system BIOS code to be run, and that's going to stand 
a much higher chance of causing unfortunate interactions with however 
Linux has set up the graphics.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
