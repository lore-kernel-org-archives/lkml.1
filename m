Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbXEWVdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbXEWVdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 17:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbXEWVcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 17:32:52 -0400
Received: from mga07.intel.com ([143.182.124.22]:1159 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755291AbXEWVcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 17:32:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,571,1170662400"; 
   d="scan'208";a="231397525"
Message-ID: <4654B2B5.4080207@linux.intel.com>
Date: Wed, 23 May 2007 14:31:33 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org
Subject: Re: Status of CONFIG_FORCED_INLINING?
References: <200705231510.52932.rob@landley.net> <46549937.1030306@linux.intel.com> <20070523212237.GH2098@stusta.de>
In-Reply-To: <20070523212237.GH2098@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> 
> What about performance reasons?
> We habe "inline" code in header files that heavily relies on being 
> nearly completely optimized away after being inlined.

fair

> Especially with -Os it could even sound logical for a compiler to never 
> inline a non-forced "inline"'d three line function with 2 callers.

but you said "I Care about size more than performance". Your argument 
is thus absolutely incorrect.

> The rules are simple:
> - every static function in a header file must be __always_inline

wrong.

> 
> Your suggestion is possible, but please also send a patch that turns 
> every "inline" in header files into __always_inline...

this is 1) insane and 2) if inlines in headers are so big gcc decides 
to not inline them.. they're too big and don't belong in the header.
