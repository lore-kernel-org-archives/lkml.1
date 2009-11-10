Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbZKJTow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbZKJTow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 14:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757875AbZKJTow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 14:44:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:30980 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757491AbZKJTov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 14:44:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=xCehAW/yLeQSvAU7Ny/HSCFrm4PzjSGNfQ9mkT5FO6RsYSgkJ9Q6qOke8lpRUhJXyd
         Up+votzSsm8hFqlzgLLB7n4iTpYIpD6NGPTPsSU2IYev8jmEgUa4GetPkDyyDU8crpKk
         dbO1E6I0D0MRo56ff8qhItMO+hlnoGUYogX+I=
Message-ID: <4AF9C2B2.3050604@gmail.com>
Date: Wed, 11 Nov 2009 04:44:50 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
References: <4AF90254.40909@kernel.org> <alpine.LFD.2.01.0911100903370.31845@localhost.localdomain> <4AF9B1FD.1010408@kernel.org> <alpine.LFD.2.01.0911101042140.31845@localhost.localdomain> <4AF9BE3A.40409@kernel.org>
In-Reply-To: <4AF9BE3A.40409@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> The return value is wrong but it wouldn't lead to oops.

Correction: It may lead to oops due to wrong end-of-list condition and
I just remembered that I was thinking about it when I was modifying
the locking and adding the switch block there and then I forgot to
actually update the return value of the extend function.  So, yeah,
three way return value sucks big time.

-- 
tejun
