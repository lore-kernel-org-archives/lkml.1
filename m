Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbYJTEPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbYJTEPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 00:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbYJTEPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 00:15:37 -0400
Received: from gw.goop.org ([64.81.55.164]:40972 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbYJTEPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 00:15:36 -0400
Message-ID: <48FC05E5.4090009@goop.org>
Date: Sun, 19 Oct 2008 21:15:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: lguest@ozlabs.org, Tiago Maluta <maluta_tiago@yahoo.com.br>,
       linux-kernel@vger.kernel.org
Subject: Re: [Lguest] lguest: unhandled trap
References: <559519.75404.qm@web50707.mail.re2.yahoo.com> <200810201039.06581.rusty@rustcorp.com.au>
In-Reply-To: <200810201039.06581.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Sunday 19 October 2008 10:36:51 Tiago Maluta wrote:
>   
>> Hi,
>>
>> I'm using 2.6.27-05323-g26e9a39 and when I try to use lguest:
>>
>> ~#Documentation/lguest/lguest 128 vmlinux
>> lguest: unhandled trap 14 at 0xc0594f6a (0xff900000)
>>     
>
> Yes, I found the same issue.  Does this fix it for you?
>
> Subject: lguest: don't try DMI
>
> dmi_scan_machine breaks under lguest; this is the simplest fix (though
> ugly).  Perhaps this hurts Xen too?
>   

No, we deal with this by just reserving the ISA memory space and leaving 
it all zero.

    J
