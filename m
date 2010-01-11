Return-Path: <linux-kernel-owner+w=401wt.eu-S1751784Ab0AKGZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab0AKGZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 01:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713Ab0AKGZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 01:25:27 -0500
Received: from mga12.intel.com ([143.182.124.36]:20851 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751526Ab0AKGZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 01:25:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="231284361"
Date: Mon, 11 Jan 2010 14:20:24 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, Huaxu Wan <huaxu.wan@intel.com>,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon: (coretemp) Fix TjMax for Atom
	N450/D410/D510 CPUs
Message-ID: <20100111062024.GA20804@ywang-moblin2.bj.intel.com>
References: <20091224073102.GA23058@ywang-moblin2.bj.intel.com> <20100106160817.72313551@hyperion.delvare> <20100110200621.564a6682@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100110200621.564a6682@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 10, 2010 at 08:06:21PM +0100, Jean Delvare wrote:
> 
> Hmm. Thinking about it some more... What about nVidia-based systems?
> Can't we have systems with an Atom N450/D410/D510 and a non-Intel
> chipset?
> 

No matter what chipset or gfx you use with the new Atom chip, the
integrated memory controller (IMC) will always be used. This patch
checks the presence of that IMC. Hope this clarifies.

Thanks
-Yong

