Return-Path: <linux-kernel-owner+w=401wt.eu-S932783AbYD2AjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783AbYD2AjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 20:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbYD2AjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 20:39:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbYD2AjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 20:39:10 -0400
Message-ID: <48166CA1.1070000@redhat.com>
Date: Mon, 28 Apr 2008 21:32:33 -0300
From: Glauber Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Sergio Luis <sergio@larces.uece.br>
CC: Ken Moffat <zarniwhoop@ntlworld.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25 slow boot/reboot
References: <48141111.7010605@larces.uece.br>	 <e2e108260804270823t45611ec2t35da085833d82dfa@mail.gmail.com>	 <20080427235554.GA28344@deepthought> <48152747.4030107@larces.uece.br>	 <4815DCEF.3000602@redhat.com> <430c4fa50804280735o3d1c3b9cg687f7d374dafbdec@mail.gmail.com>
In-Reply-To: <430c4fa50804280735o3d1c3b9cg687f7d374dafbdec@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergio Luis wrote:
> On Mon, Apr 28, 2008 at 11:19 AM, Glauber Costa <gcosta@redhat.com> wrote:
>> Sergio Luis wrote:
>>
>>> Ken Moffat wrote:
>>>
>>>> On Sun, Apr 27, 2008 at 05:23:57PM +0200, Bart Van Assche wrote:
>>>>
>>>>> On Sun, Apr 27, 2008 at 7:37 AM, Sergio Luis <sergio@larces.uece.br>
>> wrote:
>>>>>>  This weekend I got some time and decided to try out 2.6.25, but its
>> booting process was _really_ slow in my laptop[1]. With 'old' 2.6.24.5 my
>> machine would take about 48 secs until it gave me the login prompt. And it
>> would take about 22 seconds to reboot.

Sergio,

You said your system freezes. Does it happen after the last message you 
see on dmesg, or during the kernel start up? It would help me to rule 
out (or not), any issues in the cpu initialization process itself.

As for reboot, any suspicious message on your kernel log?
