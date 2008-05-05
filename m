Return-Path: <linux-kernel-owner+w=401wt.eu-S1762766AbYEEVgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762766AbYEEVgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761625AbYEEVgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:36:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:42457 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760991AbYEEVgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:36:31 -0400
In-Reply-To: <1209953499.5798.57.camel@localhost>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu> <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu> <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu> <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu> <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu> <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu> <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu> <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu> <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu> <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu> <0873f3a1f3b72591735c6461b51964693cac52e5.1209897266.git.monstr@monstr.eu> <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu> <1209953499.5798.57.camel!
 @localhost>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <6dbb712485393072564a94c3fa9b8196@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: John.Linn@xilinx.com, arnd@arndb.de, drepper@redhat.com, matthew@wil.cx,
       linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
       will.newton@gmail.com, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, microblaze-uclinux@itee.uq.edu.au,
       Michal Simek <monstr@monstr.eu>, monstr@seznam.cz
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 12/56] microblaze_v2: lmb support
Date: Mon, 5 May 2008 23:32:26 +0200
To: John Williams <john.williams@petalogix.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> --- /dev/null
>> +++ b/include/asm-microblaze/lmb.h
>
> Since LMB has a very specific (and different) meaning the microblaze
> context (LMB = Local Memory Bus), can we have a comment or explanation
> from the PPC folks on what LMB actually stands for?

See lib/lmb.c:

/*
  * Procedures for maintaining information about logical memory blocks.
  *


Segher

