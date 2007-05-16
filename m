Return-Path: <linux-kernel-owner+w=401wt.eu-S1760622AbXEPNLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622AbXEPNLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 09:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbXEPNLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 09:11:32 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:60426 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbXEPNLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 09:11:31 -0400
Message-ID: <464B02FF.1060000@s5r6.in-berlin.de>
Date: Wed, 16 May 2007 15:11:27 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "Cestonaro, Thilo \(external\)" 
	<Thilo.Cestonaro.external@fujitsu-siemens.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: How to guarantee that kmalloc returns an address below 4GB
References: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF054F922A@ABGEX01E.abg.fsc.net>
In-Reply-To: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF054F922A@ABGEX01E.abg.fsc.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cestonaro, Thilo (external) wrote:
> is there an option for kmalloc, which I can use to allocate
> a buffer which is in physical memory placed below 4GB?
> Not in a remapped area.

GFP_DMA32
http://lxr.linux.no/source/include/linux/gfp.h#L82
-- 
Stefan Richter
-=====-=-=== -=-= =----
http://arcgraph.de/sr/
