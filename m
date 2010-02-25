Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab0BYLAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 06:00:48 -0500
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:29559 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753443Ab0BYLAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 06:00:47 -0500
From: "Octavian Purdila" <opurdila@ixiacom.com>
Reply-To: <opurdila@ixiacom.com>
To: "Cong Wang" <amwang@redhat.com>
Cc: "David Miller" <davem@davemloft.net>,
       "Linux Kernel Network Developers" <netdev@vger.kernel.org>,
       "Linux Kernel Developers" <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [net-next PATCH v5 2/3] sysctl: add proc_do_large_bitmap
X-Mailer: Modest 3.1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset="utf-8"
Content-ID: <1267095756.12391.5.camel@Nokia-N900-42-11>
X-MSMail-Priority: Normal
Thread-Topic: [net-next PATCH v5 2/3] sysctl: add proc_do_large_bitmap
Thread-Index: Acq2CcgW8bUmi9Z1S+6/TZZ5CrymgA==
X-Priority: 3
Date: Thu, 25 Feb 2010 13:02:36 +0200
Message-ID: <1267095756.12391.6.camel@Nokia-N900-42-11>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I think one of them is enough, since we already chose commas, why
> do we need to add spaces? If you have some strong reason to add it,
> I have no objections.
>

It is just for simpler implementation. It is actually harder to restrict the separator to only commas insted of allowing both spaces and commas, because I rely on functions used for the integer vector handling. 

Maybe I should change those functions to be more generic and thus to allow more stricter input, but I am not sure if its worth it. Isn't a more permissive input format desirable?
