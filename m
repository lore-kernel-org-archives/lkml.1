Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230AbZJVM0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbZJVM0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbZJVM0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:26:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57731 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbZJVM0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 08:26:30 -0400
Message-ID: <4AE04DCF.6040908@zytor.com>
Date: Thu, 22 Oct 2009 21:19:27 +0900
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: mtk.manpages@gmail.com
CC: Matt Helsley <matthltc@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       randy.dunlap@oracle.com, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu,
       linux-api@vger.kernel.org, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 9/10]: Define clone3() syscall
References: <20091013044925.GA28181@us.ibm.com>	 <cfd18e0f0910152325m4a9125c2q18f36f5bd7d4a0@mail.gmail.com>	 <20091016180631.GA31036@us.ibm.com>	 <20091019174405.GE27627@count0.beaverton.ibm.com>	 <4ADCDAA8.5080408@zytor.com>	 <20091019235012.GF27627@count0.beaverton.ibm.com>	 <cfd18e0f0910202126w1ebfa2e2u2ecbaa23b198d100@mail.gmail.com>	 <4ADF06B7.50508@zytor.com>	 <cfd18e0f0910220326w1a71b899s5ff0fce9e0a2b8ed@mail.gmail.com>	 <4AE0444B.5070603@zytor.com> <cfd18e0f0910220514y1bd5967aj3a04bc3f5b38948b@mail.gmail.com>
In-Reply-To: <cfd18e0f0910220514y1bd5967aj3a04bc3f5b38948b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2009 09:14 PM, Michael Kerrisk wrote:
>
> So, sometimes, a number in a system call should be the bit width of
> some arguments(s), sometimes it should be the number of arguments, and
> sometimes (well, just occasionally, as in mmap2() and clone()) -- it
> should be a version number? Does the weather play any part in the
> decision? ;-)
>

The notion is that they are *some* kind of description on how the system 
call has been augmented.  The bitwidths and argument numbers are 
non-overlapping and visually very different, so are not subject to 
confusion.  Your argument makes about as much sense as saying the letter 
"a" should have the same meaning in every context.

	-hpa
