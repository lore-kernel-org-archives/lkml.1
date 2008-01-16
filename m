Return-Path: <linux-kernel-owner+w=401wt.eu-S1757878AbYAPW2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbYAPW2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896AbYAPWQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:16:47 -0500
Received: from ozlabs.org ([203.10.76.45]:35303 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284AbYAPWQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:16:46 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu SEGAUD <mathieu.segaud@regala.cx>
Subject: Re: [RFC on MODULE SUPPORT] hello, Rusty, Should we provide module information even if the kernel module compiled built-in with bzImage?
Date: Thu, 17 Jan 2008 09:15:25 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "rae l" <crquan@gmail.com>, open-iscsi@googlegroups.com,
       linux-kernel@vger.kernel.org
References: <91b13c310801160202y833df7bs37cbb5827e875569@mail.gmail.com> <87fxwyhtim.fsf@barad-dur.regala.cx>
In-Reply-To: <87fxwyhtim.fsf@barad-dur.regala.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801170915.26040.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 January 2008 22:58:09 Mathieu SEGAUD wrote:
> your userspace program is somewhat broken
> the userspace should not expect to find the version number in
> /sys/module, as this is used by the Linux kernel module subsystem. You
> should provide the required information in another way such as a
> /proc/ file (bad) or a /sys file (better, but no module stuff, this
> has no business with it).

Shh!  He was going to implement a feature we want!

To be honest, I think his expectations of consistency are correct: if a 
version number makes sense, surely it makes sense for builtins as well.

Thanks,
Rusty.
