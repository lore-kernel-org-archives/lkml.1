Return-Path: <linux-kernel-owner+w=401wt.eu-S933130AbYA2NkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130AbYA2NkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933028AbYA2Njs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:39:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53515 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914AbYA2Njq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:39:46 -0500
Subject: Re: scheduler scalability - cgroups, cpusets and load-balancing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Jackson <pj@sgi.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, vatsa@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       ebiederm@xmission.com, akpm@linux-foundation.org, sgrubb@redhat.com,
       rostedt@goodmis.org, ghaskins@novell.com, dmitry.adamushko@gmail.com,
       tong.n.li@intel.com, tglx@linutronix.de, menage@google.com,
       rientjes@google.com
In-Reply-To: <20080129065246.6e99fb16.pj@sgi.com>
References: <1201600428.28547.87.camel@lappy>
	 <20080129040130.7b2904b6.pj@sgi.com> <1201603816.28547.94.camel@lappy>
	 <20080129051353.4628c9eb.pj@sgi.com> <1201606284.28547.114.camel@lappy>
	 <20080129060355.7d38338f.pj@sgi.com> <1201609804.28547.137.camel@lappy>
	 <20080129065246.6e99fb16.pj@sgi.com>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 14:38:26 +0100
Message-Id: <1201613906.28547.139.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-29 at 06:52 -0600, Paul Jackson wrote:
> > Ok, I'll take a stab at understanding that code.
> 
> See also the section:
> 
>   1.7 What is sched_load_balance ?
> 
> in Documentation/cpusets.txt.
> 
> Good luck ;).

It seems Gregory tricked us both:

  57d885fea0da0e9541d7730a9e1dcf734981a173

