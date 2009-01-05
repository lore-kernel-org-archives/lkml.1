Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbZAEXIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbZAEXIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 18:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbZAEXIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 18:08:21 -0500
Received: from relay1.sgi.com ([192.48.179.29]:38736 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750760AbZAEXIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 18:08:21 -0500
Message-ID: <496292E0.5060403@sgi.com>
Date: Mon, 05 Jan 2009 15:08:16 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cpumask: update local_cpus_show to use new cpumask
 API
References: <20090105203351.785422000@polaris-admin.engr.sgi.com> <20090105203351.959649000@polaris-admin.engr.sgi.com> <200901051310.07147.jbarnes@virtuousgeek.org>
In-Reply-To: <200901051310.07147.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Monday, January 5, 2009 12:33 pm Mike Travis wrote:
>> Impact: cleanup, reduce stack usage, use new cpumask API.
>>
>> Replace the local cpumask_t variable with a pointer to the
>> const cpumask that needs to be printed.
>>
>> Signed-off-by: Mike Travis <travis@sgi.com>
>> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
>> ---
>>  drivers/pci/pci-sysfs.c |   12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> Hm, clearly there are other patches in Ingo's tree that this depends on, since 
> this patch assumes the presence of cpumask_of_pcibus and has slightly 
> different cpumask_scnprintf context.  I'll just let Ingo push the whole thing.
> 

Ok, thanks.  I saw that but I *think* all of this is in Linus' tree.

Cheers,
Mike
