Return-Path: <linux-kernel-owner+w=401wt.eu-S1762512AbXFBAnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762512AbXFBAnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 20:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbXFBAnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 20:43:13 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53324 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbXFBAnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 20:43:13 -0400
Message-ID: <4660BCF8.7000208@zytor.com>
Date: Fri, 01 Jun 2007 17:42:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Extending boot protocol & bzImage for paravirt_ops
References: <4656FB8F.4090604@goop.org> <m14pm0c0m2.fsf@ebiederm.dsl.xmission.com> <466087CF.70708@goop.org> <4660924A.2070009@zytor.com> <466093E3.4010701@goop.org> <46609636.4050208@zytor.com> <4660BBDF.1040007@goop.org>
In-Reply-To: <4660BBDF.1040007@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> Well, I think we can safely say that its something that's only
> meaningful in 32/64-bit mode, so we aren't constrained by the real-mode
> address space.
> 
> One of my goals in this project is to make the boot image, in some way,
> completely define which memory it needs it get started.  That means that
> the boot loader can either place things knowing they'll avoid the boot
> image and/or definitively know that the image is unloadable.
> 
> So I don't think its strictly necessary to pre-define what memory this
> object can use, since I think it can be safely determined dynamically.
> 

That's a method of defining the memory space.

I think the current definition is suitable for entering at the 16-bit
entry point.

	-hpa
