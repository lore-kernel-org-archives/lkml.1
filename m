Return-Path: <linux-kernel-owner+w=401wt.eu-S1756960AbYDCRrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbYDCRrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 13:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759552AbYDCRrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 13:47:20 -0400
Received: from main.gmane.org ([80.91.229.2]:35869 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759479AbYDCRrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 13:47:19 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Frederik Himpe <fhimpe@telenet.be>
Subject: Re: [REGRESSION] BCM4306 cannot associate with any version of b43
 driver
Date: Thu, 3 Apr 2008 17:47:02 +0000 (UTC)
Message-ID: <pan.2008.04.03.17.47.01@telenet.be>
References: <200804031115.52596.ace@staticwave.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 78-23-171-221.access.telenet.be
User-Agent: Pan/0.132 (Waxed in Black)
Cc: linux-wireless@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Apr 2008 11:15:52 -0400, Gabriel A. Devenyi wrote:

> I feel I have to escalate this regression to the mailing lists because
> I've had no response on the kernel bugzilla from quite some time now.
> 
> With the release of the b43 driver, my card can no longer associate with
> its AP. I've been testing with 2.6.24 and the wireless-git tree hoping
> that someone would fix it, but I've had no requests for testing and no
> response.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=9987

Is your AP using channel 13 or something like that by any chance?
Then you'll need to load mac80211 with the option ieee80211_regdom=64 to 
make this work. Add

options mac80211 ieee80211_regdom=64

to modprobe.conf and reload the mac80211 module.

-- 
Frederik Himpe

