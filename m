Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbYCaIkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbYCaIkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 04:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbYCaIjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 04:39:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:11625 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbYCaIjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 04:39:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=iUtQzqlHfnGRdquibHQJrA738mCq7FW9XDtfvE2QAKwb1czY6xB5QhmfNKyxUr5Hz2cqPEGCU/UWT50WFdsdHOb0K56ZYaPuMk3g9wjzkCzvH/rZMtif18OjI/GnDXk1ZaxsaTk5H8o2A7JaeG8xfFCDFUZHevRJ5eoquLOYAww=
Date: Mon, 31 Mar 2008 12:39:47 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com
Subject: [PATCH 0/6] Clocklib: generic clocks framework
Message-ID: <20080331083947.GA11282@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a new version based upon suggestions from Haavard and Russell.

Changes since last post:
* Split struct clk into clk and clk_ops
* Hide most non-generic things into clock type specific structs wrapping
  struct clk.
* Provide at least partial documentation for structures and fields.
* Better /sys/kernel/debug/clock formatting
* Incorporates sa1100 and PXA patches.

-- 
With best wishes
Dmitry

