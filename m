Return-Path: <linux-kernel-owner+w=401wt.eu-S1759460AbZD0UVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460AbZD0UVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756419AbZD0UVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:21:42 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:34555 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828AbZD0UVl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:21:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vR81aUPxTETFqKO8UDPZiisAIKAvDkjU8LTjylwRTROihPva/QT4PpgVgPDzx6GgPb
         wcwR4FepAuZbGhE/ixP8C0DxmOBUri/sxR92oNkEu9uzzjfIPgf9cb9ZaS628gA/glrI
         ig/3/LudaROH++Iul6fACmkipJnAkRboiIv3Q=
MIME-Version: 1.0
In-Reply-To: <20090426163924.GD6236@elte.hu>
References: <1240492586-6654-1-git-send-email-abogani@texware.it>
	 <20090426163924.GD6236@elte.hu>
Date: Mon, 27 Apr 2009 22:21:39 +0200
X-Google-Sender-Auth: 96a97d23bf2b88fc
Message-ID: <63a49ef40904271321k47e97c2y5da7f561c7591564@mail.gmail.com>
Subject: Re: [PATCH -tip] remove the BKL: remove "BKL auto-drop" assumption 
	from ext3_remount()
From: Alessio Igor Bogani <abogani@texware.it>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jonathan Corbet <corbet@lwn.net>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sir Molnar,

2009/4/26 Ingo Molnar <mingo@elte.hu>:
[...]
>> +                     unlock_kernel();
>>                       unlock_super(sb);
>>                       ext3_mark_recovery_complete(sb, es);
>>                       lock_super(sb);
>> +                     lock_kernel();
>
> Shouldnt this be a conditional-unlock, so that if the remount moves
> away from under the BKL we dont break in this place?
[...]

Please excuse me I'm only a stupid howler monkey. :-)

Patch with conditional-unlock/lock follow in a second.

Thank you!

Ciao,
Alessio
