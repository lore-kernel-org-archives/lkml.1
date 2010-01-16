Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734Ab0APCDC (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 21:03:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758696Ab0APCDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 21:03:01 -0500
Received: from snt0-omc4-s27.snt0.hotmail.com ([65.55.90.230]:55693 "EHLO
	snt0-omc4-s27.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754019Ab0APCDA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 21:03:00 -0500
Message-ID: <SNT125-W147C55AB6EB65D41CAAFFFC3680@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <yong.y.wang@linux.intel.com>, <khali@linux-fr.org>
CC: <linux-kernel@vger.kernel.org>, <huaxu.wan@intel.com>,
        <lm-sensors@lm-sensors.org>
Subject: RE: [lm-sensors] [PATCH] hwmon: (coretemp) Fix TjMax for Atom
 N450/D410/D510 CPUs
Date: Fri, 15 Jan 2010 18:02:27 -0800
Importance: Normal
In-Reply-To: <20100111062024.GA20804@ywang-moblin2.bj.intel.com>
References: <20091224073102.GA23058@ywang-moblin2.bj.intel.com>
 <20100106160817.72313551@hyperion.delvare>
 <20100110200621.564a6682@hyperion.delvare>,<20100111062024.GA20804@ywang-moblin2.bj.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 16 Jan 2010 02:02:27.0252 (UTC) FILETIME=[F3EDEF40:01CA964F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> No matter what chipset or gfx you use with the new Atom chip, the
> integrated memory controller (IMC) will always be used. This patch
> checks the presence of that IMC. Hope this clarifies.
To be more precise, Pine Trail Atoms integrate the entire northbridge, including the integrated graphics and the memory controller into the CPU, and there is a DMI connection to the southbridge, which is the Intel NM10, that is NOT integrated.
Yuhong Bao 		 	   		  
_________________________________________________________________
Hotmail: Free, trusted and rich email service.
http://clk.atdmt.com/GBL/go/196390708/direct/01/