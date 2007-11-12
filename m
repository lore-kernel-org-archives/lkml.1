Return-Path: <linux-kernel-owner+w=401wt.eu-S1757585AbXKLAmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbXKLAmp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 19:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbXKLAmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 19:42:37 -0500
Received: from mx1.univ-lille1.fr ([193.49.225.19]:48965 "EHLO
	mx1.univ-lille1.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733AbXKLAmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 19:42:36 -0500
Message-ID: <4737A09C.1030200@lifl.fr>
Date: Mon, 12 Nov 2007 01:38:52 +0100
From: Eric Piel <Eric.Piel@lifl.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.6) Gecko/20071101 Mandriva/2.0.0.6-5mdv2008.1 (2008.1) Thunderbird/2.0.0.6 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@redhat.com>
Subject: Re: Kernel panic at boot with ondemand governor as default (2.6.24-rc2)
References: <4737539F.2070401@lifl.fr> <20071111144523.14164575@laptopd505.fenrus.org>
In-Reply-To: <20071111144523.14164575@laptopd505.fenrus.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender DNS name whitelisted, not delayed by milter-greylist-2.0.2 (mx1.univ-lille1.fr [193.49.225.19]); Mon, 12 Nov 2007 01:38:55 +0100 (CET)
X-USTL-MailScanner-Information: Please contact the ISP for more information
X-USTL-MailScanner: Found to be clean
X-USTL-MailScanner-From: eric.piel@lifl.fr
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007年11月11日 23:45, Arjan van de Ven wrote/a écrit:
> On Sun, 11 Nov 2007 20:10:23 +0100
> Eric Piel <Eric.Piel@lifl.fr> wrote:
> 
>> Hello,
>>
>> I've tried kernel 2.6.24-rc2 and I have a problem with the new option 
>> for setting up the cpufreq ondemand governor as default: a kernel
>> panic happens early at boot time. If I boot first with performance
>> governor and later change to ondemand, everything is fine (as usual).
>>
>> This seems related to the delayed_workqueue. The kernel panic message 
>> finishes by:
>> EIP: [<c012aa60>] wq_per_cpu+0x0/0x10 SS:ESP 0068:c191be58
>> Kernel panic - not syncing: Attempted to kill init!
>>
>> A picture of the whole message is available here:
>> http://pieleric.free.fr/unorder/1162-ondemand-panic.jpg
>>
>> My computer is a x86 using speedstep-ich, and you can find the full 
>> .config leading to the panic attached.

> 
> has ondemand ever worked for you?
Yes, ondemand works perfectly fine on this computer. The panic happens 
only if selecting it as the _default_ governor (which has been 
introduced by commit 1c2562459faedc35927546cfa5273ec6c2884cce).

Eric


