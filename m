Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbYIPPEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbYIPPEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 11:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbYIPPDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 11:03:52 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:61158 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751222AbYIPPDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 11:03:51 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Tom Tucker <tom@opengridcomputing.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Grant Coady <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org,
       neilb@suse.de, linux-nfs@vger.kernel.org
In-Reply-To: <48CF9AC3.6060801@opengridcomputing.com>
References: <48B2D7F8.5020206@opengridcomputing.com>
	 <20080826192711.GJ4380@fieldses.org>
	 <48B567F5.2090605@opengridcomputing.com>
	 <1220111261.31172.14.camel@localhost.localdomain>
	 <20080831193037.GB14876@fieldses.org>
	 <1220211842.31172.18.camel@localhost.localdomain>
	 <48BAF643.4070808@opengridcomputing.com>
	 <1220217505.31172.26.camel@localhost.localdomain>
	 <48BC2466.2070806@opengridcomputing.com>
	 <1221036015.24993.27.camel@zakaz.uk.xensource.com>
	 <20080912224323.GN22126@fieldses.org>
	 <48CAF80A.4010109@opengridcomputing.com>
	 <1221296243.2534.7.camel@localhost.localdomain>
	 <1221544139.2534.18.camel@localhost.localdomain>
	 <48CF9AC3.6060801@opengridcomputing.com>
Content-Type: text/plain
Date: Tue, 16 Sep 2008 16:03:32 +0100
Message-Id: <1221577412.28572.60.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: NFS regression? Odd delays and lockups accessing an NFS export.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=unbeb6qN2T0A:10 a=497XeZ5pv4kA:10 a=UeMmSX8jBsfFxwOWa9MA:9 a=YV4O1bRQIY3w_igofqOZCZTEmlYA:4 a=LY0hPdMaydYA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-16 at 06:38 -0500, Tom Tucker wrote:
> Iain:

I'm actually Ian. (I don't actually mind that much, the other way round
is probably much more annoying for people called Iain).

> I'm assuming you'll do this in advance of any patch from me?

I was going to grind through it unless/until you sent a patch.

> I was simply going to add printk to the various shutdown paths and see if we 
> could get some finer grained debug output since the generic transport 
> debug output was too verbose.
> 
> Let me know and I'll help if I can,

You mean logging on the client or server side? I'm currently bisecting
client. I'm happy to add some extra prints there if you point me in the
direction of the code paths of interest.

Ian.
-- 
Ian Campbell
Current Noise: Anathema - Leave No Trace

I haven't lost my mind; I know exactly where I left it.

