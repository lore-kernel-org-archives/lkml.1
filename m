Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbZKPVuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbZKPVuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbZKPVut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:50:49 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:64338 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbZKPVus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:50:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=x3YhdJMw1Qj3/ed9uHJqQh7cf6iwa2trWzqgZAh5jG2Fs6HFzI4dXm9Hu/vxLm9hOe
         lPvIGvqoy/7u52c6zTXKrK1CxQe7leFQat+93bRvfGv9RQw3Lsha8btB4sYVI5lC0KN+
         DKG0cnl1DohQBDys8cD7Pnn2rRXGaCei4xJIc=
Date: Tue, 17 Nov 2009 00:50:52 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] INIT: Limit the number of per cpu calibration
	bootup messages
Message-ID: <20091116215052.GK5653@lenovo>
References: <20091116210718.412792000@alcatraz.americas.sgi.com> <20091116210728.267482000@alcatraz.americas.sgi.com> <20091116212427.GC2221@elte.hu> <4B01C3DB.3040802@zytor.com> <20091116214302.GJ5653@lenovo> <4B01C81F.9040000@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B01C81F.9040000@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 01:46:07PM -0800, H. Peter Anvin wrote:
> On 11/16/2009 01:43 PM, Cyrill Gorcunov wrote:
> > 
> > It seems we have one
> > 
> > 	arch/x86/kernel/setup.c:125:unsigned int boot_cpu_id __read_mostly;
> > 
> > 	-- Cyrill
> 
> We probably should make it an inline function so that if other arches
> want to define it to be a constant or some other kind of special thing
> they can.
> 
> 	-hpa
> 

IA-64 and SPARC already has this variable. But boot_cpu_id() as an
inline function seem to be more natural/portable ineed.

	-- Cyrill
