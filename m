Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbYIPR2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbYIPR2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 13:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYIPR2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 13:28:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40862 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbYIPR2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 13:28:35 -0400
Message-ID: <48CFECA1.2020009@zytor.com>
Date: Tue, 16 Sep 2008 10:28:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux@sandersweb.net, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Don't use NOPL on 32-bit cpu's because not all systems
 support it.
References: <200809161159.15870.linux@sandersweb.net>	<48CFDF82.3000704@zytor.com> <20080916180022.5f57368b@lxorguk.ukuu.org.uk>
In-Reply-To: <20080916180022.5f57368b@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Given that, we should either just rip this code out, or detect VPC 
>> (how?).  The latter option can be done post-.27, of course; if so, we 
> 
> Make the user pass a "vpcworkarounds" boot option...

<joke>
Kernel Tainted: Microsoft
</joke>

	-hpa

