Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbXFIOAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbXFIOAJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 10:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbXFIN75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 09:59:57 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:12897 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbXFIN74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 09:59:56 -0400
Date: Sat, 9 Jun 2007 15:59:55 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jon Masters <jonathan@jonmasters.org>
cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Kyle McMartin <kyle@canonical.com>,
       Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Size of kernel modules
In-Reply-To: <1181390911.3306.22.camel@jcmlaptop>
Message-ID: <Pine.LNX.4.64.0706091558460.14652@fbirervta.pbzchgretzou.qr>
References: <20070606170534.67b5dea9.Christoph.Pleger@cs.uni-dortmund.de> 
 <20070608034421.GM26717@fattire.cabal.ca>  <Pine.LNX.4.64.0706080838210.17480@localhost.localdomain>
  <Pine.LNX.4.64.0706090954310.4353@fbirervta.pbzchgretzou.qr>
 <1181390911.3306.22.camel@jcmlaptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 9 2007 08:08, Jon Masters wrote:
>
>So I missed half of this conversation - you're saying that on a
>CONFIG_DEBUG_KERNEL, you have such large .ko module files that depmod
>segfaults? Can I get a core dump or any further information? :-)

Just make sure your /lib/modules/<kernel> is like 300 megabytes or even
more. Then depmod will clog up quite a lot memory already. (Taking a 256 mb ram
machine for example, no swap or just very little.)


	Jan
-- 
