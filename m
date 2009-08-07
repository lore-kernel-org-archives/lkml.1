Return-Path: <linux-kernel-owner+w=401wt.eu-S933067AbZHGTMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067AbZHGTMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 15:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932984AbZHGTME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 15:12:04 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:44555 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932928AbZHGTMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 15:12:03 -0400
Date: Fri, 7 Aug 2009 21:11:56 +0200
From: Daniel Mack <daniel@caiaq.de>
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Libertas: Association request to the driver failed
Message-ID: <20090807191156.GS19257@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since a recent merge of the wireless tree to Linus' master, my SDIO
connected libertas module fails to connect to our WLAN.

'iwlist scanning' works fine, but wpa_supplicant keeps on spitting out
the following message:

  CTRL-EVENT-SCAN-RESULTS 
  Trying to associate with 00:04:0e:4b:c7:b3 (SSID='caiaq' freq=2437 MHz)
  Association request to the driver failed

Haven't done any bisect or deeper inspection of recent changes yet. Can
anyone point me in some direction maybe? The change must have been
introduced between -rc3 and -rc5. My userspace did not change since
then.

Thanks,
Daniel

