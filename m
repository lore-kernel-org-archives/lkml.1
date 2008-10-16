Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbYJPN6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbYJPN6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 09:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYJPN6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 09:58:25 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:15851 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbYJPN6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 09:58:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=heoaFYp6Khhqlx4VZLUmr4mgS3gU7f6c8T5ahxBZXypZ5JyqO4/bJf0aJUCVOiSnzq
         Eq7aa+ZV8K8R6EZ3gbCKAziGjPHvqhafx75R7gh7MBzZ+7kEmaSkI62DbzEWOH/lKobz
         RTgPM0OMgxPTqQtlN/2tZOAJZjqJR6ChkRx2M=
Message-ID: <386072610810160658i17ba05e0la6d2251fcb269f3d@mail.gmail.com>
Date: Thu, 16 Oct 2008 21:58:21 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Alan Cox" <alan@redhat.com>
Subject: Re: [PATCH 2/6] Blackfin Serial Driver: Add a debug function to serial driver.
Cc: gyang <graf.yang@analog.com>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
In-Reply-To: <20081015083811.GA21237@shell.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223891185-13924-1-git-send-email-cooloney@kernel.org>
	 <1223891185-13924-3-git-send-email-cooloney@kernel.org>
	 <20081014142701.72090868@lxorguk.ukuu.org.uk>
	 <1224037421.6284.40.camel@dyang>
	 <20081015083811.GA21237@shell.devel.redhat.com>
X-Google-Sender-Auth: 2d976d267055445b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 4:38 PM, Alan Cox <alan@redhat.com> wrote:
> On Wed, Oct 15, 2008 at 10:23:41AM +0800, gyang wrote:
>> We are making a SMP like patch to blackfin, cpu_relax() is replaced by a
>> data cache flush function which will count it to a per-cpu counter.
>> If this serial function is called too early, the per-cpu data area have
>> not been initialized, this call will cause crash.
>> So we'd like to use barrier() instead of cpu_relax().
>
> Can you split that out as a separate change and include the explanation in
> the patch then.
>
> Thanks
> Alan
>

I'll handle this and will resend the whole blackfin serial driver
patches again as well as Sonic updates some bug fixing recently.

Thanks
-Bryan
