Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbZJBTN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbZJBTN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 15:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbZJBTNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 15:13:25 -0400
Received: from claw.goop.org ([74.207.240.146]:56289 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926AbZJBTNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 15:13:24 -0400
Message-ID: <4AC650D6.5040800@goop.org>
Date: Fri, 02 Oct 2009 12:13:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Shirley Ma <mashirle@us.ibm.com>
CC: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Kevin Bowling <kevinb@analograils.com>,
       Andrew Jones <drjones@redhat.com>
Subject: Re: INFO: task journal:337 blocked for more than 120 seconds
References: <1254345112.8837.9.camel@localhost.localdomain>	 <4AC646D7.5030709@goop.org> <1254510407.7999.3.camel@localhost.localdomain>
In-Reply-To: <1254510407.7999.3.camel@localhost.localdomain>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/09 12:06, Shirley Ma wrote:
> On Fri, 2009-10-02 at 11:30 -0700, Jeremy Fitzhardinge wrote:
>   
>> I'm assuming from the lists you've posted to that this is under KVM? 
>> What disk drivers are you using (virtio or emulated)?
>>
>> Can you get a full stack backtrace of kjournald?
>>     
> Yes, it's under KVM, disk driver is virtio. Since the io has issue, the
> stack can't be saved on the disk. I have the image file attached here.
>   

Ah, thank you.  The backtrace does indeed look very similar.

(BTW, you could get a serial console with "qemu-kvm -nographic -append
console=ttyS0 ...")

    J
