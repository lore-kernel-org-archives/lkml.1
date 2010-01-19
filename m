Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919Ab0ASHed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab0ASHed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 02:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821Ab0ASHec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 02:34:32 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:35441 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab0ASHeb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 02:34:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sPJN4h6Q/78KvZI6EnL9GQy5FDGNFSdAJNNYsOygEO8G508PSbyWlLHgg1zNOBAd++
         1joRsy3LN7PeY9rO8SaRTDVLaqbG2fL4USPKD3pDSKvtEK4hZomWzlyTjIOc4p+spNDA
         qVVXpVRsCGbx1OtPYQ405/dLQ0x2AjmfpERU4=
MIME-Version: 1.0
In-Reply-To: <4B5557A7.5000401@cn.fujitsu.com>
References: <4104961b1001182254x74f3fcd1r906de8f10c105f8a@mail.gmail.com>
	 <4B5557A7.5000401@cn.fujitsu.com>
Date: Tue, 19 Jan 2010 15:34:31 +0800
Message-ID: <4104961b1001182334n7bd9c472r9689caf6b84788a2@mail.gmail.com>
Subject: Re: Where is proc_misc.c?
From: jidong xiao <jidong.xiao@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 2:56 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> jidong xiao wrote:
>> Hi,
>>
>> Does anybody know what happend to fs/proc/proc_misc.c? The file is
>> missing in 2.6.29. Seems like there was an cleanup, but i can't find
>> the new location of the methods. Any help appreciated.
>>
>
> $ git log -- fs/proc/proc_misc.c
> commit 59c7572e82d69483a66eaa67b46548baeb69ecf4
> Author: Alexey Dobriyan <adobriyan@gmail.com>
> Date:   Mon Oct 6 14:49:39 2008 +0400
>
>    proc: remove fs/proc/proc_misc.c
>
>    Now that everything was moved to their more or less expected places,
>    apply rm(1).
>
>    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
>
>

Oh, I see. It looks like proc_misc.c has been splited into several
files, such as cmdline.c,version.c,uptime.c,meminfo.c.Thank you.

Regards
Jason
