Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbZDTSYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbZDTSYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 14:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbZDTSYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 14:24:21 -0400
Received: from nox.protox.org ([88.191.38.29]:39853 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbZDTSYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 14:24:20 -0400
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Apr 2009 14:24:20 EDT
Subject: ioremap_wc | set_memory_(uc|wc) and suspend
From: Jerome Glisse <glisse@freedesktop.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 20 Apr 2009 20:18:10 +0200
Message-Id: <1240251490.3005.3.camel@earl.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Is this crazy|forbidden to do ioremap_wc or
set_memory_(uc|wc) in a device driver suspend
callback ? Right now on  AMD Athlon Dual Core
any calls to this functions won't return (when
called from suspend hook).

Cheers,
Jerome Glisse

