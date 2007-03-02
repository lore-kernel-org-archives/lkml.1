Return-Path: <linux-kernel-owner+w=401wt.eu-S932503AbXCBA67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbXCBA67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 19:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932643AbXCBA67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 19:58:59 -0500
Received: from gw.goop.org ([64.81.55.164]:60804 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932518AbXCBA66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 19:58:58 -0500
Message-ID: <45E776D0.9020609@goop.org>
Date: Thu, 01 Mar 2007 16:58:56 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 12/26] Xen-paravirt_ops: Fix patch site clobbers to include
 return register
References: <20070301232443.195603797@goop.org> <20070301232527.755495278@goop.org> <45E7738D.5090607@vmware.com> <45E774AB.5090103@goop.org> <45E77569.9010602@vmware.com>
In-Reply-To: <45E77569.9010602@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
>>
>> Things like what?  Do you mean the %[foo] asm parameter syntax?  I think
>> those versions are no longer supported - Arjan posted a patch a few days
>> ago to convert a pile of asms to this form.  Or do you mean something
>> else?
>>   
>
> I meant having an output in the clobber list,

There's no output in the clobber list, just "memory" and "cc".  The
paravirt_clobber() is the stuff which gets put in the .parainstructions
section which tells the patcher what registers are expected to be
modified at that callsite (including both temp and output registers).


    J
