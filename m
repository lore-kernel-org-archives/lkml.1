Return-Path: <linux-kernel-owner+w=401wt.eu-S1760629AbZCTTAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760629AbZCTTAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758940AbZCTTAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:00:08 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:61078 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760565AbZCTTAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:00:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ud4nFeiuR6IJOipRNMNZLpkHx3FnRzbj9othw8D6n349g1jMQVJ89qgXxn7RlJiH7b
         LB0ljZ6ZAwSTdcz4jw+v7VOZQpD1+RQPvk9HN3XTQwUuaEOXPJ98BEuGXg3NSuKW26Pe
         1yNCv2nuFato+msn7DtBqM85vNd1D6ZrpVaW8=
Subject: Re: [patch] x86, bts: use atomic memory allocation
From: Markus Metzger <markus.t.metzger@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
In-Reply-To: <20090320185559.GA6224@elte.hu>
References: <20090318192700.A6038@sedona.ch.intel.com>
	 <20090319161141.GA12144@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77E923FFCA4@irsmsx504.ger.corp.intel.com>
	 <20090320185559.GA6224@elte.hu>
Content-Type: text/plain
Date: Fri, 20 Mar 2009 19:59:51 +0100
Message-Id: <1237575591.6387.2.camel@raistlin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-20 at 19:55 +0100, Ingo Molnar wrote:
> * Metzger, Markus T <markus.t.metzger@intel.com> wrote:
> 

> > The second config boots OK with the additional changes to keep the 
> > GFP_KERNEL and move the ds_request_bts() calls out of the 
> > on_each_cpu() in the hw-branch-tracer.
> > 
> > I don't know yet what exactly causes the crash and if there is a 
> > simpler fix.
> 
> hm, this was an AMD box - so perhaps they dont have a compatible DS 
> implementation?

Hmmm, could be.

In that case, ds_cfg should be zero-initialized and ds_request should
return -EOPNOTSUPP. I'll try to simulate that.

regards,
markus.


