Return-Path: <linux-kernel-owner+w=401wt.eu-S1762117AbZFROsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762117AbZFROsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 10:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbZFROsC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 10:48:02 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:50442 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbZFROsB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 10:48:01 -0400
X-SpamScore: -29
X-BigFish: VPS-29(z34a4jz1432R98dR936eN1805M62a3Lzz1202hzz5a6ciz32i17ch6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KLFVR9-03-MZ2-01
Date: Thu, 18 Jun 2009 16:47:31 +0200
From: Robert Richter <robert.richter@amd.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: oprofile/op_model_amd.c set return values
	for op_amd_handle_ibs()
Message-ID: <20090618144731.GX18016@erda.amd.com>
References: <1245325167.7189.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1245325167.7189.9.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 18 Jun 2009 14:47:32.0800 (UTC) FILETIME=[B631AC00:01C9F023]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.06.09 17:09:27, Jaswinder Singh Rajput wrote:
> 
> op_amd_handle_ibs() should return 0 when IBS is not present or not defined.
> 
> Fix compilation warning:
>  CC [M]  arch/x86/oprofile/op_model_amd.o
>  arch/x86/oprofile/op_model_amd.c: In function ‘op_amd_handle_ibs’:
>  arch/x86/oprofile/op_model_amd.c:217: warning: no return statement in function returning non-void
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/oprofile/op_model_amd.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)

Applied to:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git master

Thanks Jaswinder,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

