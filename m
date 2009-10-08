Return-Path: <linux-kernel-owner+w=401wt.eu-S1751719AbZJHDpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbZJHDpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 23:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbZJHDpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 23:45:14 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:59219 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbZJHDpN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 23:45:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=K8FJahQt/pLvPGklDt+scxjoSoKrCln0ZNYI3e0SF/VUXs/3FGLF9jRe5zLYtB2nuX
         tEMflERZVaY9JPstZcq7kQ2I/GvLxLClTPG4m64wdkloN3BP/yReVllH80SZBhfOzJJC
         nH09qDofngVOxqJ6OC+D3p87KetjK/xUUSLio=
MIME-Version: 1.0
In-Reply-To: <20091005092148.4341d9ab@jbarnes-g45>
References: <cb0375e10910030939v8d03df7m861a2f05219f173c@mail.gmail.com>
	 <cb0375e10910030950kcd19fe9i7835eaaf4314c0fb@mail.gmail.com>
	 <20091005092148.4341d9ab@jbarnes-g45>
Date: Wed, 7 Oct 2009 23:44:35 -0400
X-Google-Sender-Auth: 3c09291dd0fec03e
Message-ID: <cb0375e10910072044m470c8cbasef33de3b36bb62ee@mail.gmail.com>
Subject: Re: [resend] i915: high power consumption after suspend/resume
From: Andrew Lutomirski <luto@mit.edu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 5, 2009 at 12:21 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Sat, 3 Oct 2009 12:50:01 -0400
> Andrew Lutomirski <luto@mit.edu> wrote:
>
>> [resend b/c the intel-gfx list doesn't allow non-member posting]
>>
>> Hi-
>>
>> First, thanks for all the great work on i915's power saving features
>> -- power consumption on my laptop (Lenovo X200s) is now almost as low
>> on Linux as on Windows.
>>
>> After a suspend/resume cycle, though, my power consumption usually
>> goes up by over a watt.  I think this is due to i915, because of an
>> experiment I did:
>>
>> 1. Boot with modesetting off into single user mode.
>> 2. Suspend and resume
>> 3. Reload i915 with modesetting on.  Power consumption is low.
>> 4. Suspend and resume.  Power consumption is high.
>> 5. Unbind and rebind i915.  Power consumption is high.
>> 6. Suspend.  System hangs (seperate bug, I guess).
>>
>> I get similar results if I boot single user with modesetting on: power
>> consumption is low, becomes high after suspend/resume, and goes low
>> again after rebinding i915.
>>
>> This is on 2.6.32-rc1 + a little (i.e. 84d88d5d4e from Linus' tree
>> plus an ext4 fix).  I'm having trouble reproducing any of this on
>> 2.6.31.
>
> I probably need to save/restore some more of the power saving state
> across suspend/resume...  Can you file a bug for this at
> bugs.freedesktop.org so it doesn't get lost?

Submitted as https://bugs.freedesktop.org/show_bug.cgi?id=24386

Thanks,
Andy
