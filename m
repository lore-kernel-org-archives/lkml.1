Return-Path: <linux-kernel-owner+w=401wt.eu-S965297AbXCFSpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965297AbXCFSpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966004AbXCFSps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:45:48 -0500
Received: from mail.emacinc.com ([63.245.244.68]:37739 "EHLO mail.emacinc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965297AbXCFSpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:45:47 -0500
From: NZG <ngustavson@emacinc.com>
Organization: EMAC.Inc
To: linux-kernel@vger.kernel.org
Date: Tue, 6 Mar 2007 12:46:29 -0600
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200703061246.29615.ngustavson@emacinc.com>
X-SA-Exim-Connect-IP: 63.245.244.67
X-SA-Exim-Mail-From: ngustavson@emacinc.com
Subject: passing function pointers through platform devices?
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Relay: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm developing an SPI- bus >MMC/SD block driver translation layer.
As part of this layer the write protect and card detect lines need to be read.
The method for determining the state of these lines will be board specific.

Is it appropriate to pass a function pointer through a platform device 
(declared in the mach initialization) to implement card_available and 
write_protect function calls?
Or is there a cleaner way to do it?

thank you,
NZG
