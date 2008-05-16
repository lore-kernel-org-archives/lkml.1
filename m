Return-Path: <linux-kernel-owner+w=401wt.eu-S1760704AbYEPA3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704AbYEPA3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 20:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbYEPA3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 20:29:40 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:51414 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbYEPA3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 20:29:39 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Chris Peterson <cpeterso@cpeterso.com>,
       tpmdd-devel@lists.sourceforge.net, tpm@selhorst.net,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Re: [PATCH] drivers/net: remove network drivers' last few uses of IRQF_SAMPLE_RANDOM
From: Andi Kleen <andi@firstfloor.org>
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com>
	<20080515142154.0595e475@core>
	<36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com>
	<20080515173939.1ec968be@core> <482C7DA3.1090809@garzik.org>
	<482C953A.4080205@garzik.org>
Date: Fri, 16 May 2008 02:27:36 +0200
In-Reply-To: <482C953A.4080205@garzik.org> (Jeff Garzik's message of "Thu, 15 May 2008 15:55:38 -0400")
Message-ID: <87abirytxj.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 May 2008 00:20:35.0579 (UTC) FILETIME=[A91B24B0:01C8B6EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:
>
> A hw_random driver for TPM still needs to (a) parse the TPM header for
> return code, (b) extract RNG bytes out at offset 14, and (c) figure
> out some way to get a tpm_chip pointer.

(d) auto feed the information into random.c. Otherwise it'll be useless
for most people.

-Andi
