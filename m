Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbZIFH1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbZIFH1Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 03:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbZIFH1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 03:27:15 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:42028
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754620AbZIFH1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 03:27:15 -0400
Date: Sun, 6 Sep 2009 09:27:08 +0200
From: Michael Guntsche <mike@it-loops.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.31-rc9 breaks gianfar
Message-ID: <20090906072707.GA5699@trillian.comsick.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning,

Commit 
38bddf04bcfe661fbdab94888c3b72c32f6873b3 gianfar: gfar_remove needs to call unregister_netdev()

breaks the build of the gianfar driver because "dev" is undefined in
this function. To quickly test rc9 I changed this to priv->ndev but I do
not know if this is the correct one.

Kind regards,
Michael
