Return-Path: <linux-kernel-owner+w=401wt.eu-S1760585AbXHKAJC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760585AbXHKAJC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 20:09:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbXHKAIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 20:08:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52851 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263AbXHKAIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 20:08:50 -0400
Message-ID: <46BCFE01.2040703@zytor.com>
Date: Fri, 10 Aug 2007 17:08:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Mark Cannon <random.bits@rogers.com>, linux-kernel@vger.kernel.org
Subject: Re: Use of directories to hold root?
References: <200708101724.26724.random.bits@rogers.com> <Pine.LNX.4.64.0708102332580.3054@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708102332580.3054@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Aug 10 2007 17:24, Mark Cannon wrote:
>> You pass the kernel the root option to specify the root partition.
>> Is there a way to identify a directory in that partition that holds the
>> root or something equivalent to this?
> 
> No, but you can use pivot_root.

Or better yet, use an initramfs with MS_MOVE; same as you would with the
"normal" use of initramfs.

	-hpa
