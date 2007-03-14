Return-Path: <linux-kernel-owner+w=401wt.eu-S1161169AbXCNLqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161169AbXCNLqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 07:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161171AbXCNLqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 07:46:09 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:40502 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161169AbXCNLqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 07:46:08 -0400
Message-ID: <45F7E063.7060901@s5r6.in-berlin.de>
Date: Wed, 14 Mar 2007 12:45:39 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: =?ISO-8859-15?Q?Ismail_D=F6nmez?= <ismail@pardus.org.tr>,
       linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: oops in __nodemgr_remove_host_dev
References: <200703140642.28390.ismail@pardus.org.tr> <45F7D922.6010501@s5r6.in-berlin.de>
In-Reply-To: <45F7D922.6010501@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> As a side note, the IEEE 1394 subsystem features quite a fat usage of
> the driver core. [...] Maybe we should redesign nodemgr to work without
> host devices and node entry devices.

Greg, you once indicated you had class device conversion patches for
1394 in the pipeline, but they couldn't go out to -mm or wherever
because of them depending on unfinished driver core changes.  If you
found that the 1394 subsystem needed some special treatment, there might
be a chance to eliminate this by pulling some historically grown but now
obsolete infrastructure out.  (Of course not for 2.6.21-rc anymore, but
perhaps post 2.6.21 if we take it on quickly.)
-- 
Stefan Richter
-=====-=-=== --== -===-
http://arcgraph.de/sr/
