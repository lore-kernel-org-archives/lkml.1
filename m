Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbZGBRSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbZGBRSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZGBRSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:18:45 -0400
Received: from smtp-out.google.com ([216.239.33.17]:5200 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbZGBRSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:18:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=aEkcrX7btC5epy/cNo8Om109X355paph9h52Oao/XbIO9QyNAiZf+y7PRm/svKUqF
	VBBDRlDVQhm4KgIB6aisA==
Date: Thu, 2 Jul 2009 10:18:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
In-Reply-To: <84144f020906302253n2424d4a5k3aaf124838a041df@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0907021016380.30890@chino.kir.corp.google.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <84144f020906292355o7cf63f7ch47bd19961cf92da3@mail.gmail.com> <alpine.DEB.1.10.0906301030260.6124@gentwo.org> <1246374095.8014.28.camel@penberg-laptop> <alpine.DEB.1.10.0906301114450.3879@gentwo.org>
 <alpine.DEB.2.00.0906301248000.16312@chino.kir.corp.google.com> <alpine.DEB.1.10.0906301632570.22158@gentwo.org> <alpine.DEB.2.00.0906301413460.24397@chino.kir.corp.google.com> <alpine.DEB.1.10.0906301722280.17682@gentwo.org>
 <alpine.DEB.2.00.0906301445070.26290@chino.kir.corp.google.com> <84144f020906302253n2424d4a5k3aaf124838a041df@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009, Pekka Enberg wrote:

> Lets go with the slab_out_of_memory() patch you outlined in a previous
> post and implement the slub_debug=p thing Christoph suggested. I think
> it's the best compromise at this point. When you guys finally see the
> light, we can always change it to a reasonable default. ;)
> 
> So can you send a patch, please?
> 

Sure, let me know if you think this is -rc material; otherwise, the bug 
will have to be deferred until 2.6.32 with the temporary workaround of 
disabling CONFIG_SLUB_DEBUG_ON.
