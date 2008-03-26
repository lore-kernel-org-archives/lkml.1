Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbYCZW5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbYCZW5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 18:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYCZW5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 18:57:10 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:9108 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbYCZW5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:57:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=OEDj5LGAVPZqnuw/Q5SEiE/qbvJ4ufc8p3QRzR4ocmJQ5JADOdf+8CgQQOChv7VPVFhRuZFpS0bPYOb+FlDWkI+zxIoIt+Wvy47g2su28bjq3n/S5bDyj0TZwoma55rgCHmpAtAhxsrBoHvswsxh4Ok1fW5oDGwVQDpaAH6gmR4=
Message-ID: <5b1d25eb0803261557v33e67eb8v22dc0861d3e1b255@mail.gmail.com>
Date: Wed, 26 Mar 2008 15:57:07 -0700
From: "Sreen Tallam" <tallam.sreen@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Passing parameters from u-boot to kernel in 2.6.18
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I am passing the bd_info structure from u-boot to bd_t (bd info)
structure of the kernel.

And within my platform_init, I am have the below line which assigns
the u-boot parameter to the bd structure.
Will this be enough ..

memcpy(&bd, (bd_t *)r3, sizeof(bd));

Reason is, I am not seeing the same values that I am passing from the
u-boot. Hence the question.

Is there any kernel hacking that I need to set or any thing that I may
need to be aware of?

Appreciate your help.

Thanks,
Sreen
