Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbZIVLWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbZIVLWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 07:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755988AbZIVLWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 07:22:47 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:40988 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753266AbZIVLWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 07:22:46 -0400
X-Sasl-enc: IBFvC4yzNml+2kyZFQH1hDruzBb7nE2vIRlwobQ14PPf 1253618569
Date: Tue, 22 Sep 2009 08:22:46 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Mike Galbraith <efault@gmx.de>
Cc: James Cloos <cloos@jhcloos.com>, lkml <linux-kernel@vger.kernel.org>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>
Subject: Re: Poor desktop responsiveness with background I/O-operations
Message-ID: <20090922112246.GA23987@khazad-dum.debian.net>
References: <20090920080728.73bfe2a1@infradead.org>
 <4AB5ECD0.7010903@datenparkplatz.de>
 <1253475521.9224.43.camel@marge.simson.net>
 <4AB6C73C.1030004@gmail.com>
 <1253507034.23414.90.camel@marge.simson.net>
 <4AB72FDC.5090403@datenparkplatz.de>
 <1253520364.25640.57.camel@marge.simson.net>
 <m3tyyw6pvz.fsf@lugabout.jhcloos.org>
 <1253603193.6875.118.camel@marge.simson.net>
 <1253611228.11051.2.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253611228.11051.2.camel@marge.simson.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009, Mike Galbraith wrote:
> On Tue, 2009-09-22 at 09:06 +0200, Mike Galbraith wrote:
> > I don't know if distros provide a tool that supports SCHED_IDLE, if so,
> > you can use that to set both CPU and IO usage to IDLE class in one go.
> 
> P.S.  I just remembered, don't use SCHED_IDLE with kernels < 2.6.28.
> There are two patches wrt this scheduling class which did not go to the
> stable trees less than 2.6.28.

Since 2.6.27 is long-term, maybe they should be sent to 2.6.27?  It is weird
to have a long-term stable kernel for which the recommendation is "don't use
SCHED_IDLE".

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
