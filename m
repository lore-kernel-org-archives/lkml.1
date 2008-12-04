Return-Path: <linux-kernel-owner+w=401wt.eu-S1757807AbYLDDIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807AbYLDDIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 22:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbYLDDId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 22:08:33 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:34073 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbYLDDIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 22:08:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oVbJm0VmlPGU0ZKchycWqDEOKAVfzqdJGxapCsvsKNoRjA95XP+paQuNaWwj0Y2FTj
         leo/GdrnxSMLIRlL2KNguHyHFEHPcMro/NNjz9vsAs0Ir1ALtHMhxvDME+S3aUFcM66r
         RORylW1+4lmYKq1abDN+76fj7eA63ISLjKTRw=
Message-ID: <b2b2f2320812031908se18efdft1a94cb2b158f540e@mail.gmail.com>
Date: Wed, 3 Dec 2008 21:08:30 -0600
From: "Shane McDonald" <mcdonald.shane@gmail.com>
To: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] Resurrect IT8172 IDE controller driver
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <492AAE6C.7000103@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1L4UpB-0007ro-1g@localhost> <492A8306.9000400@ru.mvista.com>
	 <492A9A1F.50401@ru.mvista.com>
	 <20081124123231.555f2395@lxorguk.ukuu.org.uk>
	 <492AAE6C.7000103@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 7:38 AM, Sergei Shtylyov
<sshtylyov@ru.mvista.com> wrote:
> Hello.
>
> Alan Cox wrote:
>
>>>>  It's 240, not 242 ns as 33 is actually 33.333.
>
>>>  The maximum values give cycle time of 480 ns menaing that the controller
>>> doesn't support PIO mode 0. Hm...
>
>> Even if you clear the enable for the timing register ?
>
>   These fast timing bits are documented as reserved.

The spec says that PIO mode 0 is supported, but Sergei is correct --
the maximum values give a cycle time of 480 ns.  How can this be?  The
old driver appeared to have tried to support PIO mode 0 by setting to
the maximum.

  Which fast timing bits are documented as reserved?  My spec has the
IDE Drive 0/1 Recovery Time and IDE Drive 0/1 Pulse Width bits in it.
Are there other timing bits that aren't documented in my spec?

  Please excuse my dumb question -- I'm a little over my head here.

>> Alan
>
> MBR, Sergei

Shane
