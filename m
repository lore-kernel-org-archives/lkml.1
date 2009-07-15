Return-Path: <linux-kernel-owner+w=401wt.eu-S1751996AbZGOFcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbZGOFcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 01:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZGOFcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 01:32:23 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:24679 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZGOFcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 01:32:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=U2Zh92ub+esOh8x28sKaBAoDe3hVpzPAM13enTxP7gA8t0N22SFPVstMdgns2nBa7w
         nfyZPC4x3eVYq9QUyKOpphWRPsObjUA31jcSQN2QIBsbcNayS7VB5ee8/oVbfnouYrXi
         aN41d9Iwx8K1qlV7LbA3Wc5a+Mc0cERHjyHEg=
Message-ID: <4A5D698E.7090606@gmail.com>
Date: Wed, 15 Jul 2009 07:30:54 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>,
       "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31-rc2: irq 16: nobody cared
References: <cV1gG-5E1-1@gated-at.bofh.it> <cVpVT-28o-3@gated-at.bofh.it>
In-Reply-To: <cVpVT-28o-3@gated-at.bofh.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2009 11:00 PM, Jiri Slaby wrote:
> On 07/06/2009 08:32 PM, Niel Lambrechts wrote:
>> Jul  6 09:45:01 localhost kernel: handlers:
>> Jul  6 09:45:01 localhost kernel: [<f8720213>] (yenta_interrupt+0x0/0xb9
>> [yenta_socket])
>> Jul  6 09:45:01 localhost kernel: Disabling IRQ #16
>
> Is there only yenta for irq 16 in /proc/interrupts before resume?

Hi,

See http://bugzilla.kernel.org/show_bug.cgi?id=13733 for an update, I experienced the problem again.

This time only yenta was loaded, and the kernel message appeared as soon as I loaded ehci_hcd.

Side note: I use pm-hibernate and both cases I experienced the problem it was some time after a resume, rather than a fresh boot.

Regards,
Niel
