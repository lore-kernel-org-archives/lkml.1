Return-Path: <linux-kernel-owner+w=401wt.eu-S1031293AbXDQXPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031293AbXDQXPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 19:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031294AbXDQXPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 19:15:50 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:45102 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031293AbXDQXPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 19:15:49 -0400
Message-ID: <4625505C.6010802@novell.com>
Date: Tue, 17 Apr 2007 15:55:24 -0700
From: Crispin Cowan <crispin@novell.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Karl MacMillan <kmacmill@redhat.com>
CC: James Morris <jmorris@namei.org>, John Johansen <jjohansen@suse.de>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: AppArmor FAQ
References: <20070416213350.GB4030@suse.de>	 <Line.LNX.4.64.0704161846110.13905@d.namei> <1176846917.5946.79.camel@localhost.localdomain>
In-Reply-To: <1176846917.5946.79.camel@localhost.localdomain>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Karl MacMillan wrote:
> On Mon, 2007-04-16 at 20:20 -0400, James Morris wrote:
>   
>> On Mon, 16 Apr 2007, John Johansen wrote:
>>     
>>> Label-based security (exemplified by SELinux, and its predecessors in
>>> MLS systems) attaches security policy to the data. As the data flows
>>> through the system, the label sticks to the data, and so security
>>> policy with respect to this data stays intact. This is a good approach
>>> for ensuring secrecy, the kind of problem that intelligence agencies have.
>>>       
>> Labels are also a good approach for ensuring integrity, which is one of 
>> the most fundamental aspects of the security model implemented by SELinux.  
>>
>> Some may infer otherwise from your document.
>>     
> Not only that, the implication that secrecy is only useful to
> intelligence agencies is pretty funny.
That was not the claim. Rather, that intelligence agencies have a very
strong need for privacy, and will go to greater lengths to get it,
including using MLS systems. I contend that while most organizations
want privacy, they don't want it so badly that they will put up with
MLS, and so are looking for a more tolerable form of security.

This is relevant here because information flow is the main advantage of
labels over pathnames for access control. AppArmor does not attempt to
manage information flow, allowing it to use pathnames to achieve ease of
use. If you want information flow control, then by all means use a
label-based system.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
Director of Software Engineering   http://novell.com

