Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbYD2Gl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbYD2Gl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 02:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbYD2Glu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 02:41:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54450 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbYD2Glu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 02:41:50 -0400
Message-ID: <4816C258.7050203@zytor.com>
Date: Mon, 28 Apr 2008 23:38:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Markus Metzger <markus.t.metzger@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: DS cleanup - dont treat 0 as NULL
References: <20080428191504.GA6842@cvg> <4816BEC8.1080708@davidnewall.com>
In-Reply-To: <4816BEC8.1080708@davidnewall.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> Cyrill Gorcunov wrote:
>> -			return 0;
>> +			return NULL;
> 
> Why?  The constant 0 is C's official symbol for a null pointer.

It's still bad style.

	-hpa
