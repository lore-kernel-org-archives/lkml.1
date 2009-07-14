Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbZGNNvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbZGNNvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 09:51:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbZGNNvC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 09:51:02 -0400
Received: from gate.crashing.org ([63.228.1.57]:59456 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbZGNNvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 09:51:01 -0400
In-Reply-To: <20090714133716.GC28970@oksana.dev.rtsoft.ru>
References: <20090616201630.GA4971@oksana.dev.rtsoft.ru> <20090714133716.GC28970@oksana.dev.rtsoft.ru>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <5D56FC27-95F2-4A9A-8955-C6D2A9BC4661@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>, linuxppc-dev@ozlabs.org,
       Steven Rostedt <srostedt@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH RFC 1/2] Makefile: Never use -fno-omit-frame-pointer
Date: Tue, 14 Jul 2009 15:46:51 +0200
To: avorontsov@ru.mvista.com
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry for not replying earlier, somehow I missed this mail]

>> On the other hand, *using* -fno-omit-frame-pointer causes gcc to
>> produce buggy code on PowerPC targets.

It doesn't cause the problem, it only exposes it.  And, of course,
only on certain GCC versions.

>> Segher, do you know if all GCC versions that we support for
>> building Linux are behaving the way that GCC manual describe?

I believe so, yes.


Segher

