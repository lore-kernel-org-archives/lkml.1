Return-Path: <linux-kernel-owner+w=401wt.eu-S1759241AbXINMAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbXINMAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 08:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbXINMAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 08:00:09 -0400
Received: from main.gmane.org ([80.91.229.2]:41643 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbXINMAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 08:00:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Carlos Corbacho <cathectic@gmail.com>
Subject: Re: [PATCH] Make wistron-btns recognize special keys on Medion WIM2160 notebooks
Date: Fri, 14 Sep 2007 12:56:58 +0100
Message-ID: <fcdsp2$q18$1@sea.gmane.org>
References: <200709141337.36398.bero@arklinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: bb-87-81-255-5.ukonline.co.uk
User-Agent: KNode/0.10.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Rosenkraenzer wrote:

> The patch below adds support for Medion WIM2160 notebooks to the
> wistron-btns driver.

Do these keys emit proper scancodes though? If yes (i.e. you press a button
and get a warning about "unknown scancodes" in dmesg), then they should not
be added to wistron-btns, but to hal-info in userspace.

-Carlos
-- 
E-Mail: cathectic@gmail.com
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D

