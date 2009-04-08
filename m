Return-Path: <linux-kernel-owner+w=401wt.eu-S932686AbZDHSk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686AbZDHSk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932451AbZDHSjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:39:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:47280 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272AbZDHSj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:39:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DgCrbQNTbk2HKbytGS2I7sMQVxSfS9J+Fm/ExbmtUyA88sibaQjglhiFiT6SkxBr36
         ZghDDSxnb94z7Q6I5iOlO7vLJh65MmPGldOu65+aWh0S9qUI4Q4cSzaOgKUJ1X2ANhiO
         kuBIJ8E5aADtihmDTHq7tbzug5kv5rPGLQuR8=
Date: Wed, 8 Apr 2009 22:39:24 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86: make wakeup_secondary_cpu_via_init static
Message-ID: <20090408183924.GF7556@lenovo>
References: <49D6A692.6040400@kernel.org> <tip-cdc1cb0d4445f39561a65204d26f89365f917550@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-cdc1cb0d4445f39561a65204d26f89365f917550@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Yinghai Lu - Wed, Apr 08, 2009 at 01:00:32PM +0000]
| Commit-ID:  cdc1cb0d4445f39561a65204d26f89365f917550
| Gitweb:     http://git.kernel.org/tip/cdc1cb0d4445f39561a65204d26f89365f917550
| Author:     Yinghai Lu <yinghai@kernel.org>
| AuthorDate: Fri, 3 Apr 2009 17:15:14 -0700
| Committer:  Ingo Molnar <mingo@elte.hu>
| CommitDate: Wed, 8 Apr 2009 14:50:28 +0200
| 
| x86: make wakeup_secondary_cpu_via_init static
| 
| Impact: cleanup
| 
| Signed-off-by: Yinghai Lu <yinghai@kernel.org>
| LKML-Reference: <49D6A692.6040400@kernel.org>
| Signed-off-by: Ingo Molnar <mingo@elte.hu>
| 
| 
| ---
|  arch/x86/kernel/smpboot.c |    2 +-
|  1 files changed, 1 insertions(+), 1 deletions(-)
| 
| diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
| index 58d24ef..bddf2cc 100644
| --- a/arch/x86/kernel/smpboot.c
| +++ b/arch/x86/kernel/smpboot.c
| @@ -538,7 +538,7 @@ wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
|  	return (send_status | accept_status);
|  }
|  
| -int __devinit
| +static int __devinit
|  wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
|  {
|  	unsigned long send_status, accept_status = 0;

Hi Yinghai,

just curious why it's not __cpuinit? Did I miss something?

       Cyrill
