Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbYIQHOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbYIQHOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 03:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbYIQHN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 03:13:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:42737 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbYIQHN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 03:13:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M/iSmdzCW7u+fVUpeKa+mwbx++6yjp7qC7xhKWnLtDTvwX13ziCyCJAzG9UcwEuXWP
         +sq78RHPTApXZrgG5da8Zdv9jCxVvC2VHzzrWrYTjQInEU0yG5ARWs/SoqIqcoQyT/6j
         TTUxNg1Q8UKgQIq6MNon/tgekE4MziYO1pkYA=
Date: Wed, 17 Sep 2008 11:13:57 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: j_kernel@hoblitt.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bugme-new] [Bug 11543] New: kernel panic: softlockup in
	tick_periodic() ???
Message-ID: <20080917071357.GA7455@lenovo>
References: <20080917024312.GA23209@hoblitt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080917024312.GA23209@hoblitt.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[j_kernel@hoblitt.com - Tue, Sep 16, 2008 at 04:43:12PM -1000]
| In-Reply-To: <20080916175629.GE7187@lenovo>
| On Tue, Sep 16, 2008 at 09:56:29PM +0400, Cyrill Gorcunov wrote:
| > [Thomas Gleixner - Tue, Sep 16, 2008 at 07:14:40AM -0700]
| > | Can you try nmi_watchdog=2 ?
| > | 
| > | Thanks,
| > | 
| > | 	tglx
| > | 
| > 
| > And get apic=debug a try too please. I remember there
| > was a problem with SB600 on ACPI side (but they should
| > be already fixed)
| 
| Attached is the updated dmesg from adding the nmi_watchdog=2 and acpi=debug boot params.
| 
| -J
| 

Joshua, could you please attach ACPI tables dump to the bugzilla entry (~300K)?
Not sure if it help but could be usefull info. Thanks for this dmesg - trying
to analize it.

(
here is how to do it
	http://kernel.org/pub/linux/kernel/people/helgaas/debug
	http://lwn.net/Articles/237085/
)

		- Cyrill -
