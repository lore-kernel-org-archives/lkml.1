Return-Path: <linux-kernel-owner+w=401wt.eu-S932178AbXINVPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbXINVPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 17:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758874AbXINVPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 17:15:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758064AbXINVPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 17:15:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
X-Fcc: ~/Mail/linus
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dan Aloni <da-x@monatomic.org>, Bernhard Walle <bwalle@suse.de>
Subject: Re: [PATCH] Add ELF note with Linux version
In-Reply-To: Sam Ravnborg's message of  Friday, 14 September 2007 23:07:38 +0200 <20070914210738.GA5031@uranus.ravnborg.org>
References: <20070904150018.GA4357@suse.de>
	<46DFD825.2020109@goop.org>
	<20070913144228.2efcd5d9.akpm@linux-foundation.org>
	<20070913221340.GA29181@uranus.ravnborg.org>
	<46E9BD3D.4050102@goop.org>
	<20070914060805.GA32169@uranus.ravnborg.org>
	<46EAE534.5030900@goop.org>
	<20070914210738.GA5031@uranus.ravnborg.org>
X-Windows: the joke that kills.
Message-Id: <20070914211537.47FDF4D0424@magilla.localdomain>
Date: Fri, 14 Sep 2007 14:15:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The right fix for the linker script is to use the NOTES macro after RODATA.
I'm pretty sure this has been posted before.  Each arch's vmlinux.lds.S
needs that change, but the details vary if it uses an explicit PHDRS.


Thanks,
Roland
