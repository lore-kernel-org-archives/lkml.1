Return-Path: <linux-kernel-owner+w=401wt.eu-S1758988AbXEMSBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988AbXEMSBn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 14:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756929AbXEMSBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 14:01:36 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:22120 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbXEMSBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 14:01:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b+wC35vbLhMeaAMVNMLLHZu4h/QWWTA35hu0lpK+YI2jxPgcGt7a0vkrvI9SSPYZJieZmRgwP4KbPbkwG9wTqyaoV4F9OCg9q0OU268aeFrXYpiOawmFbLkCEabGrBsMbSWMSLMtnqrWMIc/85VT5M/3cDJ6EeQy2N6MIM8/3mY=
Message-ID: <86802c440705131101r5b32e0b9j28e2248813b25b64@mail.gmail.com>
Date: Sun, 13 May 2007 11:01:33 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH]x86_64: build and use GDT on copied compressed kernel
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Vivek Goyal" <vgoyal@in.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440705130027vce147dma85a07de6489d666@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440705122233y327756e7te534199f46b2059d@mail.gmail.com>
	 <m1ejllqmo8.fsf@ebiederm.dsl.xmission.com>
	 <86802c440705122329y27c6ef92v8cff43d52b99ae69@mail.gmail.com>
	 <m1abw9qkve.fsf@ebiederm.dsl.xmission.com>
	 <86802c440705122355r5f811d5bg2006b0b22ca885e6@mail.gmail.com>
	 <m11whlqk1g.fsf@ebiederm.dsl.xmission.com>
	 <86802c440705130027vce147dma85a07de6489d666@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

I got one question about kexec and bzImage on 64bit kernel.

The bzImage for 64bit kernel must be loaded under 4G?
but vmlinux for 64bit kernel could be loaded above 4G.

So is there any plan to use 64bit entry point (startup_64) in
arch/x86_64/boot/compressed/vmlinux in bzImage? so you may
load bzImage above 4G too.

YH
