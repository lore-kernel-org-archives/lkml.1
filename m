Return-Path: <linux-kernel-owner+w=401wt.eu-S933883AbZJGBlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883AbZJGBlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 21:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933764AbZJGBlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 21:41:00 -0400
Received: from trinity.develer.com ([83.149.158.210]:38656 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933352AbZJGBk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 21:40:59 -0400
Subject: Re: sata_mv 0000:03:06.0: PCI ERROR; PCI IRQ cause=0x30000040
From: Bernie Innocenti <bernie@codewiz.org>
To: Mark Lord <liml@rtr.ca>
Cc: Harri Olin <harri.olin@gmail.com>, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, sysadmin <sysadmin@gnu.org>
In-Reply-To: <1254873978.1471.463.camel@giskard>
References: <1254546642.1438.135.camel@giskard> <4ACA6904.1060509@rtr.ca>
	 <4ACB3741.2030101@gmail.com> <1254852272.1471.172.camel@giskard>
	 <4ACBA33C.7090606@rtr.ca>  <1254873978.1471.463.camel@giskard>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Sugar Labs - http://www.sugarlabs.org/
Date: Tue, 06 Oct 2009 21:40:18 -0400
Message-Id: <1254879618.1471.525.camel@giskard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-1.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 06-10-2009 a las 20:06 -0400, Bernie Innocenti escribió:
> > The early revs of these chips did have a number of errata specific to PCI-X.
> 
> I checked the revision (09) against the sata_mv source and I couldn't
> spot anything relevant to us.

NEWSFLASH: today we replaced the 4x500GB Seagate drives with 4x1.5TB
drives and reconstruction of the array has been running for 2h without a
glitch.

One interesting difference is that the 500GB drives were being
configured in 1.5Gbps SATA mode.  Another notable difference is the
sequential read speed: ~70MB/s vs ~130MB/s with the 1.5TB model.

Could the PCI bus errors be a red herring?

-- 
   // Bernie Innocenti - http://codewiz.org/
 \X/  Sugar Labs       - http://sugarlabs.org/

