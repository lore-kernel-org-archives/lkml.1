Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbYJHUlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbYJHUlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 16:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbYJHUlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 16:41:31 -0400
Received: from main.gmane.org ([80.91.229.2]:35363 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbYJHUlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 16:41:31 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Frederik Himpe <fhimpe@telenet.be>
Subject: Re: 2.6.27-rc8-git8: oops in process hald-addon-dell-backlight
 (intel iommu related?)
Date: Wed, 8 Oct 2008 20:41:23 +0000 (UTC)
Message-ID: <pan.2008.10.08.20.41.23@telenet.be>
References: <pan.2008.10.08.20.15.37@telenet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 78-21-61-244.access.telenet.be
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Oct 2008 20:15:37 +0000, Frederik Himpe wrote:

> On my Dell Latitude E6400 system with Intel chipset and graphics, I get
> this oops in my 2.6.27-rc8-git8 based kernel, which probably happens
> when hald-addon-dell-backlight is started.
> 
> Complete dmesg and lspci info:
> https://qa.mandriva.com/show_bug.cgi?id=44711

Booting with intel_iommu=off seems to fix this issue, and seems to make my 
e1000e based network card stop from giving "transmit timed out" errors 
after which it stopped working.

-- 
Frederik Himpe

