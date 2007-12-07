Return-Path: <linux-kernel-owner+w=401wt.eu-S1751640AbXLGHSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbXLGHSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 02:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbXLGHS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 02:18:26 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:2210 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbXLGHSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 02:18:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=g4e/rlWC93T9J0zowxsG5bmixWY/DEQejqwsQv2wAHFsE7cWLAhmWz25W+meeOu+W+d/NMX0diVAR7KbQpAROJLvPktkHV3KSq+YQYzQgW/g86Bc4xu5ItdMAkffOA/JDV0avD3sHuQeZYBTpVmJzweaD9Bs0EjLkAat5zvZVSs=
Message-ID: <3d8471ca0712062318j483f8be6h256778752a13639a@mail.gmail.com>
Date: Fri, 7 Dec 2007 08:18:22 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Cc: "Stefano Brivio" <stefano.brivio@polimi.it>, "Ingo Molnar" <mingo@elte.hu>,
       "Robert Love" <rml@tech9.net>, linux-kernel@vger.kernel.org,
       "Dave Jones" <davej@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Michael Buesch" <mb@bu3sch.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Len Brown" <lenb@kernel.org>
In-Reply-To: <alpine.LFD.0.99999.0712070646210.3221@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071207021952.6f0ac922@morte>
	 <alpine.LFD.0.99999.0712070646210.3221@localhost.localdomain>
X-Google-Sender-Auth: 717da62d2163f548
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 7, 2007 6:51 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Hmrpf. sched_clock() is used for the time stamp of the printks. We
> need to find some better solution other than killing off the tsc
> access completely.

Something like http://lkml.org/lkml/2007/3/16/291 that would need some refresh?

-- 
Guillaume
