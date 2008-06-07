Return-Path: <linux-kernel-owner+w=401wt.eu-S1760116AbYFGNnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116AbYFGNnO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 09:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754913AbYFGNnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 09:43:03 -0400
Received: from userg501.nifty.com ([202.248.238.81]:47970 "EHLO
	userg501.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbYFGNnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 09:43:01 -0400
DomainKey-Signature: a=rsa-sha1; s=userg501; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:content-transfer-encoding;
	b=loYAZKcg8gI8eyfSHnvWQBm/Vfklg8mwR1bpQx+guKsyJjEftdwgBFcJ60ldDePQf
	kdMXeI+t++/qOrzNql4+g==
X-Nifty-SrcIP: [220.145.29.246]
Date: Sat, 7 Jun 2008 22:37:16 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: linux-kernel@vger.kernel.org
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-pcmcia <linux-pcmcia@lists.infradead.org>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>
Subject: [KERNEL 2.6.26-rc4]  bugreport : pata_pcmcia with Sandisk Extreme
 III 8GB
Message-Id: <20080607223716.7d142072.komurojun-mbn@nifty.com>
In-Reply-To: <20080530135728.be02d3dc.Kristoffer.Ericson@Gmail.com>
References: <20080528225049.9a134e0d.Kristoffer.Ericson@Gmail.com>
	<20080528222740.GB20893@isilmar.linta.de>
	<20080530135728.be02d3dc.Kristoffer.Ericson@Gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008 13:57:28 +0200
Kristoffer Ericson <kristoffer.ericson@gmail.com> wrote:


> > > pcmcia: registering new device pcmcia1.0
> > ...
> > > pcmcia: registering new device pcmcia1.1
> > > 1.1: GetNextTuple: No more items
> > > pata_pcmcia: probe of 1.1 failed with error -12

This problem is introduced at kernel 2.6.26-rc4.

The kernel 2.6.26-rc3 does not have this problem.


Best Regards
Komuro


> 
> > Hi,
> > 
> > > Ive added the id123 strings for a Sandisk Extreme III 8GB.
> > > I get this when using pcmcia->CF adapter.
> > 
> > > pcmcia: registering new device pcmcia1.0
> > ...
> > > pcmcia: registering new device pcmcia1.1
> > > 1.1: GetNextTuple: No more items
> > > pata_pcmcia: probe of 1.1 failed with error -12
> > 
> > Is that a multifunction device? It seems to me that something is broken in
> > the device CIS, for both drives seem to be exported already by device
> > pcmcia1.0.
> 
> Its a simply pcmcia->CF adapter and the CF card is a simple storage one. I got it to work through USB-adapter after replacing my
> broken one.
> However it still doesnt work through the pcmcia->CF adapter.
> 
> Im not ruling out that its broken though.
> 
> > 
> > Best,
> > 	Dominik
> 
> 
> -- 
> Kristoffer Ericson <Kristoffer.Ericson@Gmail.com>
> 
> _______________________________________________
> Linux PCMCIA reimplementation list
> http://lists.infradead.org/mailman/listinfo/linux-pcmcia


-- 
Komuro <komurojun-mbn@nifty.com>
