Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbXFMQ3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbXFMQ3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 12:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758162AbXFMQ33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 12:29:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887AbXFMQ32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 12:29:28 -0400
Date: Wed, 13 Jun 2007 12:29:25 -0400
From: Dave Jones <davej@redhat.com>
To: Alex Bennee <kernel-hacker@bennee.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: DRI/AGP on AMD64 based machine
Message-ID: <20070613162925.GG3875@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Alex Bennee <kernel-hacker@bennee.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <1181721735.4418.10.camel@malory>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181721735.4418.10.camel@malory>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 09:02:15AM +0100, Alex Bennee wrote:
 > Hi,
 > 
 > For a while now I've been meaning to get DRI running with my rv350
 > graphics card on my AMD64 machine. However I don't seem to be able to
 > get the right config-fu in the kernel to enable all the components.
 > 
 > For my sins I've been following the Gentoo Howto Wiki
 > (http://gentoo-wiki.com/HOWTO_DRI_with_ATi_Open-Source_Drivers)
 > 
 > A lot of the AGP stuff in the Kernel seems to be locked to 32 bit
 > kernels. The instructions seem to imply there is an am64-agp module
 > (which looks as though it builds in the tree but doesn't install) and
 > possibly an nvidea-agp module. I'm a little confused as I have both AMD
 > and NVidia chipsets on my machine:

For the sake of AGP, we only use the on-CPU GART.
The (nvidia) chipset one is ignored.

If amd64-agp isn't working for you, attach your dmesg.
(You can also confirm its working by running testgart[1])

	Dave

[1] http://www.codemonkey.org.uk/projects/agp/testgart.c

-- 
http://www.codemonkey.org.uk
