Return-Path: <linux-kernel-owner+w=401wt.eu-S1758759AbZEKT20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbZEKT20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755948AbZEKT2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:28:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42027 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756986AbZEKT2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:28:03 -0400
Message-ID: <4A087BF8.9010709@zytor.com>
Date: Mon, 11 May 2009 12:26:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@kernel.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: Addition of cpufeatures to friendly	access
 miscellaneous MSRs
References: <1242058494.5139.7.camel@ht.satnam> <4A086B58.30607@zytor.com> <20090511184727.GF10722@erda.amd.com>
In-Reply-To: <20090511184727.GF10722@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter wrote:
> 
> Anyway, I think this was already decided. So, maybe for debugging we
> should simply read the msrs with rdmsr_safe() and use the exception
> handler to check if the msr is implemented. This would avoid most of
> the otherwise unused cpufeature flags above.
> 

For that use, it's probably the right thing to do.

(FWIW, I agree that dumping MSRs in userspace is the right thing to do. 
  This is being heavily discussed on the util-linux-ng list, as far as I 
can tell.)

	-hpa

