Return-Path: <linux-kernel-owner+w=401wt.eu-S1756278AbZGCNqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbZGCNqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 09:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbZGCNqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 09:46:03 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:41299 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753605AbZGCNqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 09:46:02 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
In-Reply-To: <1246626771-11345-1-git-send-email-pbonzini@redhat.com>
References: <1246626771-11345-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain
Date: Fri, 03 Jul 2009 14:28:08 +0100
Message-Id: <1246627688.3928.227.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] xen: wait up to 5 minutes for device connection
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=CsXI0TdRxGAA:10 a=tHz9FfFoAAAA:8 a=20KFwNOVAAAA:8 a=hvPqsL0ILZ8d80I7k1AA:9 a=fkf8Lo05UuqHshNuA0Ts8kCyr-YA:4 a=6O0IECtVFhoA:10 a=jEp0ucaQiEUA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-03 at 15:12 +0200, Paolo Bonzini wrote:
> Increases the device timeout from 10s to 5 minutes, giving the user a visual
> indication during that time in case there are problems.  The patch is a
> backport of changesets 144, 146, 150 and 909 in the Xenbits tree.
> 
> Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Acked-by: Ian Campbell <ian.campbell@citrix.com>

Although with the recent printk changes you might need to sprinkle some
KERN_CONT around the place.

Ian.

-- 
Ian Campbell

"Cable is not a luxury, since many areas have poor TV reception."
		-- The mayor of Tucson, Arizona, 1989

