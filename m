Return-Path: <linux-kernel-owner+w=401wt.eu-S936116AbXHHQYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936116AbXHHQYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936009AbXHHQXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:23:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:59866 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935012AbXHHQXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:23:49 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 5/5] x86_64 EFI support -v3: EFI document
Date: Wed, 8 Aug 2007 18:22:07 +0200
User-Agent: KMail/1.9.6
Cc: "Huang, Ying" <ying.huang@intel.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
References: <1185851583.23149.30.camel@caritas-dev.intel.com> <200708081208.01080.ak@suse.de> <m1tzrac8hz.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1tzrac8hz.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081822.07758.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> This is the classic skip the 16bit code and enter the kernel
> in 32bit mode filling in the fields that the 16bit mode code would
> have filled in the same way approach.

kexec can use it because it's in tree.

But I don't think using it by out of tree stuff is a good idea.

e.g. assuming we need a new field. How would we extend this?
There is no version number or anything to detect this.

For in tree code it can be just updated. But weirdo-EFI-boot loader
cannot.

-Andi
