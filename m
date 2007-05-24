Return-Path: <linux-kernel-owner+w=401wt.eu-S1751144AbXEXRTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751144AbXEXRTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbXEXRT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:19:26 -0400
Received: from mga05.intel.com ([192.55.52.89]:48026 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750802AbXEXRT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:19:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,574,1170662400"; 
   d="scan'208";a="249330359"
Message-ID: <4655C8B8.7020205@linux.intel.com>
Date: Thu, 24 May 2007 10:17:44 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>, Rob Landley <rob@landley.net>,
       linux-kernel@vger.kernel.org
Subject: Re: Status of CONFIG_FORCED_INLINING?
References: <200705231510.52932.rob@landley.net> <46549937.1030306@linux.intel.com> <20070523212237.GH2098@stusta.de> <Pine.LNX.4.61.0705241829000.31549@yvahk01.tjqt.qr> <20070524171404.GC4470@stusta.de>
In-Reply-To: <20070524171404.GC4470@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Thu, May 24, 2007 at 06:29:39PM +0200, Jan Engelhardt wrote:
>> On May 23 2007 23:22, Adrian Bunk wrote:
>>> And we need only two different inline levels (__always_inline and
>>> "let the compiler decide"), not three (__always_inline, inline and
>>> "let the compiler decide").
>> "inline" is "let the compiler decide". If it is not, then it is "let the
>> compiler decide, based on my bias that I think it should be inlined".
> 
> Wrong.
> "static" is "let the compiler decide".
> 
and "inline" is "give the compiler a suggestion". Not more than that.
