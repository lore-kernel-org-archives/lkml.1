Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbZKCPp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbZKCPp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbZKCPp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:45:57 -0500
Received: from mail-qy0-f174.google.com ([209.85.221.174]:44065 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbZKCPp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:45:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Kp2fiduXSJ4uvKh8yM5CCbwizAOXCi+rtxmm5lkbABpNZ/9Cp3Oy+o5wPf39bh7trm
         PVk2Wge6uNq9Sj+9FquqN3OBiH7vC9+6bO607ICUSsBmVi9XF9Bcq8trOFQbJJgB4kD3
         GLzGN8/QBwrgSqObilwY/Ttelgru6Jdj+vLgA=
Message-ID: <4AF05047.5090403@gmail.com>
Date: Tue, 03 Nov 2009 16:46:15 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5pre) Gecko/20091028 SUSE/3.0b4-5.1 Thunderbird/3.0pre
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, hbabu@us.ibm.com,
       kexec@lists.infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: kdump fails to load and crashes [was: mmotm 2009-11-01-10-01
 uploaded]
References: <200911011807.nA1I7o95016136@imap1.linux-foundation.org> <4AEF673E.5030509@gmail.com> <20091103144450.GB4235@redhat.com> <4AF048D1.4090402@gmail.com> <20091103152448.GC4235@redhat.com>
In-Reply-To: <20091103152448.GC4235@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2009 04:24 PM, Vivek Goyal wrote:
>> There /proc/iomem looks like:
>> 00100000-12beffff : System RAM
>>   01000000-04ffffff : Crash kernel
>>     01000000-014680c2 : Kernel code
>>     014680c3-016f39f7 : Kernel data
>>     0175b000-017d97ab : Kernel bss
...
> Anyway, can you just try reserving memory at some other address, say
> 64M@32M and see if it works.

Yup, that's it of course. I missed it overlaps with current kernel. I
though they are areas for the crash kernels. Thanks for pointing out. So
the error is we reserve the space for kdump even we can't in fact?
