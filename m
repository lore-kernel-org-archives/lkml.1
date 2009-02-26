Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbZBZUCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbZBZUCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 15:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbZBZUCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 15:02:23 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:13292 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbZBZUCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 15:02:22 -0500
Message-ID: <49A6F50E.3070100@hp.com>
Date: Thu, 26 Feb 2009 15:01:18 -0500
From: Brian Haley <brian.haley@hp.com>
Organization: Open Source and Linux Organization
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Chuck Lever <chuck.lever@oracle.com>
CC: Jay Vosburgh <fubar@us.ibm.com>, David Miller <davem@davemloft.net>,
       arvidjaar@mail.ru, vladislav.yasevich@hp.com, tytso@mit.edu,
       Valdis.Kletnieks@vt.edu, rjw@sisk.pl, netdev@vger.kernel.org,
       bonding-devel@lists.sourceforge.net, jamagallon@ono.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] bonding: move IPv6 support into a separate kernel
 module
References: <49A5ADB3.2010709@hp.com> <28797.1235599858@death.nxdomain.ibm.com> <20090225.141430.166906161.davem@davemloft.net> <49A6C6ED.3070801@hp.com> <22876.1235672073@death.nxdomain.ibm.com> <49A6ED6D.3090508@hp.com> <F613EEFD-2332-4C75-A486-73CDF2BAADDE@oracle.com>
In-Reply-To: <F613EEFD-2332-4C75-A486-73CDF2BAADDE@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Lever wrote:
>> I think changing ipv6 to support a disable_ipv6 module parameter like 
>> Vlad suggested would work, as long as we're not worried about someone 
>> opening an AF_INET6 socket - even if they do they won't get anywhere.
> 
> In this case, if IPV6ONLY is set on an AF_INET6 listener, it should 
> still get AF_INET traffic, correct?

No, it should get nothing, and a send should get ENETUNREACH.

-Briian
