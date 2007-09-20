Return-Path: <linux-kernel-owner+w=401wt.eu-S1752053AbXITVIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbXITVIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 17:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbXITVID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 17:08:03 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4840 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbXITVH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 17:07:59 -0400
Date: Thu, 20 Sep 2007 16:33:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Paul Mundt <lethal@linux-sh.org>, Michael Buesch <mb@bu3sch.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] ssb: Make pcmciahost depend on PCMCIA=y
Message-ID: <20070920203323.GM6748@tuxdriver.com>
References: <20070912021100.GB26827@linux-sh.org> <200709121209.10068.mb@bu3sch.de> <20070912101745.GA23417@linux-sh.org> <200709121259.00700.mb@bu3sch.de> <20070913014333.GA26541@linux-sh.org> <20070920194231.GB31759@nineveh.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070920194231.GB31759@nineveh.local>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 03:42:31PM -0400, Joseph Fannin wrote:

>     I just ran into this link error (CONFIG_PCMCIA=m;
> CONFIG_SSB_PCMCIAHOST=y).  No big deal; I don't have the hardware.
> 
>     But yeah, this is still a problem.

config SSB_PCMCIAHOST_POSSIBLE
        bool
        depends on SSB && PCMCIA && EXPERIMENTAL
        default y

config SSB_PCMCIAHOST
        bool "Support for SSB on PCMCIA-bus host (EXPERIMENTAL)"
        depends on SSB_PCMCIAHOST_POSSIBLE
        help

What tree are you using?

-- 
John W. Linville
linville@tuxdriver.com
