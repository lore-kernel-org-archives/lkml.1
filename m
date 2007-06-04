Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbXFDMM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbXFDMM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 08:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbXFDMMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 08:12:52 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:3994 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbXFDMMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 08:12:52 -0400
Date: Mon, 4 Jun 2007 14:12:50 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -mm] 1/2: MMCONFIG: validate against ACPI motherboard resources
Message-ID: <20070604121250.GA33621@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Robert Hancock <hancockr@shaw.ca>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <465CF794.1070406@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465CF794.1070406@shaw.ca>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 10:03:32PM -0600, Robert Hancock wrote:
> -Validate that the area is reserved even if we read it from the
> chipset directly and not from the MCFG table. This catches the case
> where the BIOS didn't set the location properly in the chipset and
> has mapped it over other things it shouldn't have.

Just for the record, I still fundamentally disagree with that part.
You're not catching what you think you're catching, since the chipset
tells you what it is going to decode as mmconfig, no matter what is
connected to it.

  OG.
