Return-Path: <linux-kernel-owner+w=401wt.eu-S932460AbXA1IDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460AbXA1IDE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 03:03:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932445AbXA1IDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 03:03:04 -0500
Received: from terminus.zytor.com ([192.83.249.54]:49661 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461AbXA1IDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 03:03:03 -0500
Message-ID: <45BC5700.9030109@zytor.com>
Date: Sat, 27 Jan 2007 23:55:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: caglar@pardus.org.tr
CC: Avi Kivity <avi@qumranet.com>, lkml <linux-kernel@vger.kernel.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: [PATCH] KVM: 'asm' operand has impossible constraints
References: <200701260140.47760.caglar@pardus.org.tr> <45BB15F1.6020600@qumranet.com> <200701272328.31532.caglar@pardus.org.tr>
In-Reply-To: <200701272328.31532.caglar@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

S.Çağlar Onur wrote:
> 
> "g" means "r"+"i" so the register allocator in the -O0 case is selecting "r" 
> while in the optimize case is selecting "i"
> 

"g" means "rmi", not "ri".

	-hpa
