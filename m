Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab0CCCYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 21:24:36 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38182 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab0CCCYe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 21:24:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=IN3Uacf8p1jcrVdVFCVQjUSrWVJEafXLyQn1d7n9BnC7aloUPTOxogu3oOwq9m9wjV
         AuOLcRr++u4BCkq1RuGOiet7/SGfuF0jjXPX/ZxC/Lld/gul5LkvAAknUt16JaC9j2kJ
         ULyGDm9Xsju3c0NR97mxz/NqsFUN3NB+4ORTI=
MIME-Version: 1.0
In-Reply-To: <20100303105911.D63A.A69D9226@jp.fujitsu.com>
References: <322581998527c77c89d6fb91b8cbe02b5637c6dc.1267156293.git.andre.goddard@gmail.com> 
	<20100302124206.4e0a42b4.akpm@linux-foundation.org> <20100303105911.D63A.A69D9226@jp.fujitsu.com>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Tue, 2 Mar 2010 23:17:54 -0300
Message-ID: <b8bf37781003021817v31591ca6gedd6eedb0255d3c@mail.gmail.com>
Subject: Re: [PATCH] binfmt_elf: plug a memory leak situation on dump_seek()
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Roland McGrath <roland@redhat.com>, WANG Cong <amwang@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kosaki Motohiro, Andrew,

>> Please don't send unchangelogged patches.
>>
>> Explain the leak.
>>
>> Explain the user impact (ie: how it is triggered).
>>
>> Explain how the patch fixes it.
>>
>> Thanks.
>
> Hi Andre,
>
> plus, can you please rebase this patch onto -mmotm tree? it have lots elf core dump related
> fix and it is going to be merged at this merge window, maybe.
>
> I think your patch is correct. but I hope to avoid patch confliction.
>
> Thanks.
>

    Sure, I'm going to include a proper changelog, rebase it on top of
-mmotm tree and send a new patch soon.

Thank you,
André
