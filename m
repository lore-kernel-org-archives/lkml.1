Return-Path: <linux-kernel-owner+w=401wt.eu-S1758318AbZIOSya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318AbZIOSya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 14:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757949AbZIOSyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 14:54:25 -0400
Received: from BACHE.ECE.CMU.EDU ([128.2.129.23]:35270 "EHLO bache.ece.cmu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbZIOSyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 14:54:25 -0400
Message-ID: <4AAFE25E.3040307@cmu.edu>
Date: Tue, 15 Sep 2009 14:52:14 -0400
From: "Jonathan M. McCune" <jonmccune@cmu.edu>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, jbeulich@novell.com, jmorris@namei.org,
       tpmdd-devel@lists.sourceforge.net, m.selhorst@sirrix.com,
       Andrew Morton <akpm@linux-foundation.org>, Roland.Dreier@us.ibm.com
Subject: Re: [tpmdd-devel] [PATCH] TPM: Fixup pubek sysfs file
References: <20090904045231.GW4973@obsidianresearch.com>	 <adaab1bnvz3.fsf@cisco.com>	 <20090904140325.c592289a.akpm@linux-foundation.org>	 <20090904212316.GZ406@obsidianresearch.com>	 <17754_1252731784_n8C533ou010944_20090911162837.GC17677@kroah.com>	 <4AAE84EA.8010109@  <20090914194626.GF25981@obsidianresearch.com> <1252983983.3745.67.camel@dyn9002018117.watson.ibm.com>
In-Reply-To: <1252983983.3745.67.camel@dyn9002018117.watson.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   
>>> Although it may be worth discussing whether this functionality should be  
>>> moved from the driver into IMA.
> 
> Are you really suggesting moving the tpm_pcr_read()/extend() to IMA?
> Why?
> 

I mentioned this since I'm not aware of anything else in the kernel that 
uses this functionality.  But this may also be a case of "it ain't 
broke, so don't fix it."

Cheers,
-Jon
