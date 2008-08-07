Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbYHGFDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbYHGFDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 01:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbYHGFCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 01:02:54 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48781 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753604AbYHGFCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 01:02:53 -0400
Date: Thu, 7 Aug 2008 00:02:51 -0500
From: Paul Jackson <pj@sgi.com>
To: "Rakib Mullick" <rakib.mullick@gmail.com>
Cc: menage@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset.c : Removes extra variable
Message-Id: <20080807000251.d5a81641.pj@sgi.com>
In-Reply-To: <b9df5fa10808060550y483d1c1dh99bac10c158510df@mail.gmail.com>
References: <b9df5fa10808060550y483d1c1dh99bac10c158510df@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Andrew - I reverse my 'NAQ' on this patch.

Acked-by: Paul Jackson <pj@sgi.com>


Rakib wrote:
> I think we should concentrate on how it will be executed.

Aha - you're right.  Your patch saves 12 bytes of kernel
text space (x86_64 arch).  I had assumed that the compiler
would optimize my inessential cpus_nonempty variable out of
existence, but that is not the case.

Thanks for persuing this, Rakib.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
