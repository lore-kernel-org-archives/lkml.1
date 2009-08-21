Return-Path: <linux-kernel-owner+w=401wt.eu-S932161AbZHUADG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161AbZHUADG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 20:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932104AbZHUADG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 20:03:06 -0400
Received: from hiauly1.hia.nrc.ca ([132.246.100.193]:3584 "EHLO
	hiauly1.hia.nrc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbZHUADF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 20:03:05 -0400
Subject: Re: kernel segv with 2.6.31-rc6 ?
To: roland@redhat.com (Roland McGrath)
Date: Thu, 20 Aug 2009 20:03:04 -0400 (EDT)
From: "John David Anglin" <dave@hiauly1.hia.nrc.ca>
Cc: James.Bottomley@HansenPartnership.com, deller@gmx.de,
       rusty@rustcorp.com.au, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, dave.anglin@nrc.ca
In-Reply-To: <20090820232357.934474730F@magilla.sf.frob.com> from "Roland McGrath" at Aug 20, 2009 04:23:57 pm
X-Mailer: ELM [version 2.4 PL25]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-Id: <20090821000304.AEDE64E09@hiauly1.hia.nrc.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> arch/parisc/Makefile:
> 
> 	# Without this, "ld -r" results in .text sections that are too big
> 	# (> 0x40000) for branches to reach stubs.
> 	ifndef CONFIG_FUNCTION_TRACER
> 	  cflags-y	+= -ffunction-sections
> 	endif

Thus, the .text.* sections must be coming from .S files, or possibly
from dwarf2 debug output.

Dave
-- 
J. David Anglin                                  dave.anglin@nrc-cnrc.gc.ca
National Research Council of Canada              (613) 990-0752 (FAX: 952-6602)
