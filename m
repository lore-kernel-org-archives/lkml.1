Return-Path: <linux-kernel-owner+w=401wt.eu-S2993119AbXEBNFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993119AbXEBNFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 09:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993126AbXEBNFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 09:05:19 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:57412 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993119AbXEBNFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 09:05:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=EQW/+5gv1a/OKHYRaUtmOLqvIbJU/LoKbhBNhdV8DpUTY3w+ZF91dz7/ppUndHZCPetra0/f7r4rNmgwg0aipzGi4d1k7igWz+Aw5pdMAdPchJR/s4AHjOfwV91QBqzVGOC5YZAwtmdkw9gxSobPQxEpW8/YlcjV56d9JDAPexs=
Message-ID: <46388C43.8020800@gmail.com>
Date: Wed, 02 May 2007 15:04:03 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: gregkh@suse.de, dmitry.torokhov@gmail.com, oneukum@suse.de,
       rpurdie@rpsys.net, stern@rowland.harvard.edu, maneesh@in.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] sysfs: sysfs rework, take #2
References: <11777675753460-git-send-email-htejun@gmail.com> <20070502143808.37dd5ff0@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070502143808.37dd5ff0@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Sat, 28 Apr 2007 22:39:35 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> All the known regrssions are fixed.  I think I've got all the
>> attr->owner but haven't verified with cross compiling yet, just
>> allyesconfig on x86-64 and i386.  I'll try to setup some cross compile
>> environments tomorrow and follow up if I can find more fallouts.
> 
> s390 attr->owner seems to be fine afaics.
> 
> I've run some stress tests (attach/detach) on s390 and haven't run into
> any problems yet.

Great, thanks a lot for testing.  I've long stress tests but the only
oops I've seen (which I'm trying to reproduce without success) is caused
by deallocated platform device when udev for it is generated.  So, I
think the sysfs changes are pretty stable.

-- 
tejun
