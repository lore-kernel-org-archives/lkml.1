Return-Path: <linux-kernel-owner+w=401wt.eu-S1760592AbXHXUjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760592AbXHXUjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 16:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbXHXUjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 16:39:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:51243 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbXHXUjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 16:39:24 -0400
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: sparclinux@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       parisc-linux@parisc-linux.org
Subject: Re: errno codes intertwined
References: <Pine.LNX.4.64.0708241815540.28540@fbirervta.pbzchgretzou.qr>
From: Andi Kleen <andi@firstfloor.org>
Date: 24 Aug 2007 22:39:23 +0200
In-Reply-To: <Pine.LNX.4.64.0708241815540.28540@fbirervta.pbzchgretzou.qr>
Message-ID: <p738x80y8ec.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@computergmbh.de> writes:
> 
> So I'm just asking: can I rely on the same errno across Linuxes?

No. The errnos were originally designed to be compatible
with the "native" Unix on that platform to make running
their binaries easier. On Sparc that would
be SunOS/Solaris.

-Andi
