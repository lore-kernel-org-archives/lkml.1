Return-Path: <linux-kernel-owner+w=401wt.eu-S1750979AbXBXLbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750979AbXBXLbZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 06:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbXBXLbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 06:31:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36331 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbXBXLbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 06:31:24 -0500
From: Andreas Schwab <schwab@suse.de>
To: Richard Purdie <rpurdie@rpsys.net>
Subject: Nvidiafb broken in 2.6.21-rc1
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
X-Yow: -- I can do ANYTHING ... I can even ... SHOPLIFT!!
Date: Sat, 24 Feb 2007 12:31:11 +0100
Message-ID: <jezm737pxc.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.21-rc1 I get no video signal from nvidiafb on PowerMac G5.
Bisection has identified this patch:

commit 599a52d12629394236d785615808845823875868
Author: Richard Purdie <rpurdie@rpsys.net>
Date:   Sat Feb 10 23:07:48 2007 +0000

    backlight: Separate backlight properties from backlight ops pointers
    
    Per device data such as brightness belongs to the indivdual device
    and should therefore be separate from the the backlight operation
    function pointers. This patch splits the two types of data and
    allows simplifcation of some code.
    
    Signed-off-by: Richard Purdie <rpurdie@rpsys.net>

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
