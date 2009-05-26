Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbZEZNyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbZEZNyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 09:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbZEZNyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 09:54:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44009 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbZEZNym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 09:54:42 -0400
Message-ID: <4A1BF491.1090501@redhat.com>
Date: Tue, 26 May 2009 16:54:25 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Rusty Russell <rusty@rustcorp.com.au>, kvm-devel <kvm@vger.kernel.org>,
       lguest <lguest@ozlabs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Lguest] [PATCH] lguest: fix on Intel when KVM loaded (unhandled
 trap 13)
References: <200905262054.42566.rusty@rustcorp.com.au> <20090526123914.1823adae@lxorguk.ukuu.org.uk>
In-Reply-To: <20090526123914.1823adae@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Tue, 26 May 2009 20:54:41 +0930
> Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>   
>> When KVM is loaded, and hence VT set up, the vmcall instruction in an
>> lguest guest causes a #GP, not #UD.
>>
>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>>     
>
> Shouldn't that be fixed in KVM ?
>   

KVM never saw that VMCALL or #GP.

-- 
error compiling committee.c: too many arguments to function

