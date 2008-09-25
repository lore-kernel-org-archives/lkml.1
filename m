Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbYIYAXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbYIYAXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 20:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbYIYAXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 20:23:40 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:15453 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbYIYAXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 20:23:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AozXAYOPpzD5+iKwTPFZJkCQ6Jfl3EpLwAnbTQs+R65sPuund4TE5rosF6G3wAExGf
         f4Z9c4ralykRw1IbPBsvuzlEYQ+Xj9SvB8TIF7fUyYI3MwY/kICEk/dDC3nSL2v9o3Uv
         9SFJC9TCZYrku7qDlDQx7mHG3vnzi2/CZRD8U=
Date: Thu, 25 Sep 2008 08:23:33 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: Cristi Magherusan <cristi.magherusan@net.utcluj.ro>
Cc: Yan Li <elliot.li.tech@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 1/2] VMware guest detection for x86 and x86-64
Message-ID: <20080925002333.GD21049@yantp.cn.ibm.com>
References: <48D12490.5010003@zytor.com> <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com> <1222265424.5708.5.camel@localhost> <20080924142322.GA21049@yantp.cn.ibm.com> <1222279994.27604.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222279994.27604.2.camel@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 09:13:14PM +0300, Cristi Magherusan wrote:
> > > We can also use this feature to force the HZ value to 100 or 250 at most
> > > when running in a virtual environment, since VirtualBox had some issues
> > > with this by taking a lot of CPU time when the HZ was set to 1000.
> > 
> > That's good. But this function is used for detecting VMware guest
> > only.  Do you think VMware also suffers from this problem?
> > 
> I don't know for sure about VMware, but someone who has it installed can
> try it. I had this issue with a CentOS 5-server virtual machine
> downloaded from http://www.thoughtpolice.co.uk/vmware/
> 
> The fix consisted in using a kernel compiled with the HZ value set to
> 100 instead of the default which was 1000.

Oh I never heard about this. I've been using several VMware VMs
(combined RHEL and SLES and Debian) but haven't seen such
issue. What's the symptom?


-- 
Li, Yan
