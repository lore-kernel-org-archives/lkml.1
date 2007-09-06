Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbXIFKQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbXIFKQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 06:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbXIFKP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 06:15:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36402 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbXIFKP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 06:15:57 -0400
Date: Thu, 6 Sep 2007 11:14:37 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: "Andreas Herrmann" <andreas.herrmann3@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Robert Richter" <robert.richter@amd.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space access
 for AMD Barcelona
Message-ID: <20070906111437.76343d44@laptopd505.fenrus.org>
In-Reply-To: <20070905150027.GD22086@alberich.amd.com>
References: <20070903081736.288288000@amd.com>
	<20070903081736.588599000@amd.com>
	<20070903013157.72c94891@laptopd505.fenrus.org>
	<20070903091718.GB22144@alberich.amd.com>
	<20070903043319.7573875b@laptopd505.fenrus.org>
	<20070903154734.GC22086@alberich.amd.com>
	<46DE45A2.40403@zytor.com>
	<20070905150027.GD22086@alberich.amd.com>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Sep 2007 17:00:27 +0200
"Andreas Herrmann" <andreas.herrmann3@amd.com> wrote:

> On Wed, Sep 05, 2007 at 06:58:58AM +0100, H. Peter Anvin wrote:
> > Well, they don't add any functionality, do they?
> 
> They allow CF8/CFC to access ECS in cases where mmcfg is not working.
> 

just for the record; I have absolutely no problem with allowing the new
cf8 method (I'm assuming that it's obvious that if mmio is available,
that will be used instead for performance reasons). What I was/am
concerned/uncomfortable about is keying this off the CPU level rather
than a PCI level property; I much rather would see this keyed of, say,
the PCI ID of the root bridge, or ideally from some PCI property.
