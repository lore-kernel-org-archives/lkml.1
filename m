Return-Path: <linux-kernel-owner+w=401wt.eu-S966073AbXCTBty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966073AbXCTBty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 21:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966071AbXCTBty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 21:49:54 -0400
Received: from gw.goop.org ([64.81.55.164]:47613 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966070AbXCTBtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 21:49:53 -0400
Message-ID: <45FF3CB1.7080301@goop.org>
Date: Mon, 19 Mar 2007 18:45:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andi Kleen <ak@muc.de>, David Miller <davem@davemloft.net>,
       rusty@rustcorp.com.au, mingo@elte.hu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, chrisw@sous-sol.org,
       anthony@codemonkey.ws, torvalds@linux-foundation.org,
       netdev@vger.kernel.org
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
References: <20070316.023331.59468179.davem@davemloft.net> <45FB005D.9060809@goop.org> <1174127638.8897.75.camel@localhost.localdomain> <20070318.003309.71088169.davem@davemloft.net> <20070318120814.GA45869@muc.de> <45FD619D.6030402@goop.org> <20070318170414.GB45869@muc.de> <45FD76E6.4060907@goop.org> <20070318193030.GB71548@muc.de> <45FDCF52.4000805@goop.org> <45FF3793.5050308@vmware.com>
In-Reply-To: <45FF3793.5050308@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Jeremy Fitzhardinge wrote:
>>  If we then work out in each direction and see matched push/pops,
>> then we know what registers can be trashed in the call.  This also
>> allows us to determine the callsite size, and therefore how much space
>> we need for inlining.
>>   
>
> No, that is a very dangerous suggestion.  You absolutely *cannot* do
> this safely without explicitly marking the start EIP of this code. 
> You *must* use metadata to do that.  It is never safe to disassemble
> backwards or "rewind" EIP for x86 code. 

What do you mean the instruction before is "mov $0x52515000,%eax"?

Yeah, you're right.  Oh well.

    J
