Return-Path: <linux-kernel-owner+w=401wt.eu-S1759310AbXGWNMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbXGWNMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 09:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbXGWNMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 09:12:25 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:40622 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbXGWNMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 09:12:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ixMRW1naFhwFyE/HXmRjhm/GGAiBtbpiLXfC6NopUFRHXT+P3HSl/hwHVE/11iOZJjIaSzfnAs9yND1WPhbBT4iALWAk0PC0PnDaPS+oD+UzCyBH6rkLB6Uofdp28wCUZq4sSVZJMzA0pUtK9AePl8U/LCaY6/0HhZ5BJ36Eia8=
Message-ID: <4104961b0707230612l7250489dk6064b9cd2170bfaf@mail.gmail.com>
Date: Mon, 23 Jul 2007 21:12:22 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: What does irq_canonicalize mean?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I found this function, inside include/asm-i386/irq.h or
include/asm-x86_64/irq.h,

static __inline__ int irq_canonicalize(int irq)
{
	return ((irq == 2) ? 9 : irq);
}

there is no comments,so I am totally confused what does this function
mean, why there is a "2", and why there is a "9"?

Thanks
Jason Xiao
