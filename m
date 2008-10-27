Return-Path: <linux-kernel-owner+w=401wt.eu-S1751893AbYJ0QUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbYJ0QUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYJ0QUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:20:19 -0400
Received: from ox1.aei.mpg.de ([194.94.224.6]:44925 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbYJ0QUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:20:18 -0400
Date: Mon, 27 Oct 2008 17:20:54 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tomas.winkler@intel.com, kernel@nn7.de
Subject: Suspend to RAM regression in 2.6.28-rc2 (bisected)
Message-ID: <20081027162054.GA4015@localhost.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So I managed to bisect my suspend to RAM regression in 2.6.27-rc2
to commit 3b7ee69d0caefbdb85a606a98bff841b8c63b97e ("mac80211: disassociate 
when moving to new BSS") by Tomas Winkler (Cc:-ed).

Unfortunately it doesn't revert cleanly so I can't double check it.

My laptop is a Vaio FZ240E Core2Duo@2GHz and I use the iwlagn module
for the wireless connection.

The symptom is that suspending to RAM from inside X with 'echo mem >
/sys/power/state' leaves me a black screen when resuming back.

I can test any patches and provide more information of my laptop too.
