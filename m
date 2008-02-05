Return-Path: <linux-kernel-owner+w=401wt.eu-S1756990AbYBEEuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbYBEEuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 23:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbYBEEuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 23:50:05 -0500
Received: from mga10.intel.com ([192.55.52.92]:27183 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753408AbYBEEuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 23:50:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,304,1199692800"; 
   d="scan'208";a="295853421"
Message-ID: <47A7EA88.3020404@linux.intel.com>
Date: Mon, 04 Feb 2008 20:48:08 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: issue with patch "x86: no CPA on iounmap"
References: <20080205011357.GA14712@linux-os.sc.intel.com>
In-Reply-To: <20080205011357.GA14712@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Siddha, Suresh B wrote:
> This is wrt to x86 git commit f56d005d30342a45d8af2b75ecccc82200f09600
> 	"x86: no CPA on iounmap"
> 
> This can use performance issue. When a GART driver unmaps a RAM page,

thinking about this some more...

afaik the gart driver doesn't use ioremap....

(and it does caching control explicitly, and sets its pages back to cached)

