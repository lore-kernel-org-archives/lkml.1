Return-Path: <linux-kernel-owner+w=401wt.eu-S1758833AbYH0QTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833AbYH0QTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbYH0QTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:19:16 -0400
Received: from gw.goop.org ([64.81.55.164]:46585 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632AbYH0QTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:19:15 -0400
Message-ID: <48B57E81.2020708@goop.org>
Date: Wed, 27 Aug 2008 09:19:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Louis.Rilling@kerlabs.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [RFC v2][PATCH 4/9] Memory management - dump state
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu>	 <Pine.LNX.4.64.0808202304490.17436@takamine.ncl.cs.columbia.edu>	 <1219437422.20559.146.camel@nimitz> <48B0F449.2000006@cs.columbia.edu>	 <1219768406.8680.17.camel@nimitz> <48B49C61.1040003@cs.columbia.edu>	 <1219851696.8680.67.camel@nimitz>	 <20080827155725.GD14473@hawkmoon.kerlabs.com> <1219853520.8680.69.camel@nimitz>
In-Reply-To: <1219853520.8680.69.camel@nimitz>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Wed, 2008-08-27 at 17:57 +0200, Louis Rilling wrote:
>   
>> On Wed, Aug 27, 2008 at 08:41:36AM -0700, Dave Hansen wrote:
>>     
>>> Dang.  What's the thing we return from system calls that are
>>> unsupported?  Did I just dream that up?
>>>       
>> ENOSYS?
>>     
>
> Brain not functioning, yet.  Thanks.
>   

Or EOPNOTSUPP - but that's documented as a network error ("Operation not
supported on transport endpoint").

    J
