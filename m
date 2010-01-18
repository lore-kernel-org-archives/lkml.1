Return-Path: <linux-kernel-owner+w=401wt.eu-S1752247Ab0ARJON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab0ARJON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 04:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166Ab0ARJON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 04:14:13 -0500
Received: from mga05.intel.com ([192.55.52.89]:29074 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751135Ab0ARJOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 04:14:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,292,1262592000"; 
   d="scan'208";a="765080232"
Date: Mon, 18 Jan 2010 17:18:01 +0800
From: Huaxu Wan <huaxu.wan@linux.intel.com>
To: Peter Feuerer <peter@piie.net>
Cc: Rudolf Marek <r.marek@assembler.cz>, Huaxu Wan <huaxu.wan@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Coretemp Atom 330, strange temperatures
Message-ID: <20100118091801.GA9804@owl>
References: <cone.1263640262.140101.28399.1000@deskpiie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cone.1263640262.140101.28399.1000@deskpiie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:11 Sat 16 Jan, Peter Feuerer wrote:
> Hi Rudolf, Hi Huaxu,
> 
> I've got an Asrock Ion 330 machine with Atom 330 processor, running
> 2.6.32.3 kernel. When loading coretemp it shows strange
> temperatures, like this:
> Core0: 0.0 degree C
> Core1: 16.0 degree C
> Core2: 0.0 degree C
> Core3: 15.0 degree C
> 
> Is there an offset missing? When touching the cooler it feels like 40 degree ore something.
> Is this a known problem? Is there already a fix?
> 

AFAIK, the thermal sensor has a range limitation, it may report an incorrect
value when the temperatures are ~20C below Tcontrol(40~50). Could you give
some load to it and check the temperatures again?


Thanks
Huaxu
