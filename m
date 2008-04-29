Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbYD2GXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbYD2GXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 02:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYD2GXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 02:23:12 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:34437 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751024AbYD2GXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 02:23:11 -0400
Message-ID: <4816BEC8.1080708@davidnewall.com>
Date: Tue, 29 Apr 2008 15:53:04 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Markus Metzger <markus.t.metzger@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: DS cleanup - dont treat 0 as NULL
References: <20080428191504.GA6842@cvg>
In-Reply-To: <20080428191504.GA6842@cvg>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> -			return 0;
> +			return NULL;

Why?  The constant 0 is C's official symbol for a null pointer.
