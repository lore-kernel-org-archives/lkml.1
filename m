Return-Path: <linux-kernel-owner+w=401wt.eu-S1757497AbYHATis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbYHATis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 15:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbYHATil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 15:38:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34307 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbYHATik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 15:38:40 -0400
Message-ID: <48936615.4040900@zytor.com>
Date: Fri, 01 Aug 2008 12:37:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Containers <containers@lists.osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: Per-instance devpts
References: <20080412172933.GA19295@us.ibm.com>	 <1208027215.28187.17.camel@x61.ebiederm.org>  <48935205.3090807@zytor.com> <1217618624.20260.50.camel@nimitz>
In-Reply-To: <1217618624.20260.50.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Fri, 2008-08-01 at 11:12 -0700, H. Peter Anvin wrote:
>> 1. /dev/ptmx would have to change to a symlink, ptmx -> pts/ptmx.
> ...
>> I worry #1 would have substantial user-space impact, but I don't see a 
>> way around it, since there would be no obvious way to associate 
>> /dev/ptmx with a filesystem.
> 
> Are your worries just about replacing what is now a normal file with a
> symlink, and the behavioral changes that come with that?  
> 
> I wonder if using a bind mount for the file would be more robust.  We
> wouldn't, of course, be able to do it persistently, but I bet it would
> be something we could count on udev to do for us.

No, I'm concerned about the changes needed for udev and setup scripts.

	-hpa
