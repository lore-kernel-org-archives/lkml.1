Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbYFLFhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbYFLFhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 01:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbYFLFhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 01:37:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:16071 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbYFLFho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 01:37:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wDoO+6aI5tgW7b/g1PsL+NCo/7TmqZrL6M7xPH/kOs7q64mDKlA2GSRqkLFp1yPUoK
         lxLNp1XFOY6r5PbMgRUNcbwlOfoO9xC30wBc8OvX7vEaJqsps4YSu0DwR+z4Qht1ftyn
         20zvPLef5iDyxChHZFfuRjXnagboF/0Fh/rnQ=
Message-ID: <19f34abd0806112237l34653a96qdbcdaf829f90cf1d@mail.gmail.com>
Date: Thu, 12 Jun 2008 07:37:44 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Len Brown" <lenb@kernel.org>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.26-rc5
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       "Linux Power Management List" <linux-pm@lists.osdl.org>,
       "Lin Ming" <ming.m.lin@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <19f34abd0806112231m69bd521fgbce3c5f8dd413423@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0806111942510.12191@localhost.localdomain>
	 <19f34abd0806112231m69bd521fgbce3c5f8dd413423@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 7:31 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> Hi,
>
> On Thu, Jun 12, 2008 at 1:44 AM, Len Brown <lenb@kernel.org> wrote:
>> please pull from:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
>>
>> This will update the files shown below.
>
> What about the "ACPICA: Fixes for Unload and DDBHandles" patch?
>
> http://bugzilla.kernel.org/show_bug.cgi?id=10669
>

Hm, sorry, I only looked for the patch title in your series. It seems
to be this entry:

commit 8410565f540db87ca938f56f92780d251e4f157d
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Jun 10 14:29:26 2008 +0800

   ACPICA: Fix for access to deleted object <regression>

   Fixes problem introduced in 20080123, with fix for Unload operator.
   Parse tree object can be already deleted; must use the opcode
   within the WalkState.

   ACPI: kmemcheck: Caught 16-bit read from freed memory
   http://bugzilla.kernel.org/show_bug.cgi?id=10669

   Signed-off-by: Lin Ming <ming.m.lin@intel.com>
   Signed-off-by: Bob Moore <robert.moore@intel.com>
   Signed-off-by: Len Brown <len.brown@intel.com>

but now it has a completely new title and a new author? This looks
like just the fix, I couldn't find the original patch (which had a
nice title and description on its own). Hm.

Thanks, and sorry for the noise.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
