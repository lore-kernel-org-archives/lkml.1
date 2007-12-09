Return-Path: <linux-kernel-owner+w=401wt.eu-S1752407AbXLISKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbXLISKZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 13:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbXLISKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 13:10:11 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:9930 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbXLISKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 13:10:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Kl1BhzmXZh3uXCnVusZSulavuagIAbD7wRjKNuBDzVKmz7+8YvJo6R8unXJ6F5+UJhQQ8wAl3vES+0CaLk8pk0yA7kfVhEna/L89MaJxrgSMgRamH2RZJemycixctb0FyCt3npBsfIgGgmk7gi175SD3iVfEtxyFxlcPNZk+ek0=
Message-ID: <3d8471ca0712091010p1dd0de12h4f9dd1037d87223@mail.gmail.com>
Date: Sun, 9 Dec 2007 19:10:07 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [git pull] x86/hrtimer/acpi fixes
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Fernando Lopez-Lezcano" <nando@ccrma.stanford.edu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, "Len Brown" <lenb@kernel.org>,
       "Venki Pallipadi" <venkatesh.pallipadi@intel.com>
In-Reply-To: <20071209180149.GJ4381@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071207183633.GC26778@elte.hu>
	 <1197053386.32023.13.camel@cmn3.stanford.edu>
	 <20071207185920.GA3006@elte.hu>
	 <1197055769.32023.22.camel@cmn3.stanford.edu>
	 <1197056910.32023.25.camel@cmn3.stanford.edu>
	 <20071207195958.GA12529@elte.hu> <20071209180149.GJ4381@ucw.cz>
X-Google-Sender-Auth: 3c8cb941969c1adc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 9, 2007 7:01 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > + *  ns += offset to avoid sched_clock jumps with cpufreq
> > + *
> >   *                   -johnstul@us.ibm.com "math is hard, lets go shopping!"
> >   */
>
> Did john add the 'ns+=' or do comments need reorder?

I added it, but I think it needs to be removed as now the offset is maintained
by the scheduler in __update_rq_clock().

Thanks.

-- 
Guillaume
