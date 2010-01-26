Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382Ab0AZN5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab0AZN5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 08:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412Ab0AZN5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 08:57:16 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:40690 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab0AZN5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 08:57:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=ERySSidYPO+7hTDqMt1q9hK3U385RaDoRqO0C4yxMKUBRFkXqVCp/DSCPQo/RQTncF
         STuT5m6tLBka7O4fRhjcB1kNnBzIyLwh3dv7OPNfbSsaJFdvjM4EpPgIoDV5ZcjU7o5z
         EATMpQmY8owQRhFk7tN1xdzl9RwC2QtJ83Btk=
MIME-Version: 1.0
In-Reply-To: <20100126141055.5AAD.A69D9226@jp.fujitsu.com>
References: <20100125104728.4935.A69D9226@jp.fujitsu.com>
	 <op.u63v1pxzasvm2a@kedge>
	 <20100126141055.5AAD.A69D9226@jp.fujitsu.com>
Date: Tue, 26 Jan 2010 15:57:13 +0200
X-Google-Sender-Auth: 26d47b55414f3b31
Message-ID: <84144f021001260557x4357632cla355d4e6c9632504@mail.gmail.com>
Subject: Re: OOM-Killer kills too much with 2.6.32.2
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Roman Jarosz <kedgedev@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>, michael@reinelt.co.at,
       jcnengel@googlemail.com, rientjes@google.com, earny@net4u.de,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       jithin1987@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 7:19 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> (cc to lots related person)
>
>> On Mon, 25 Jan 2010 02:48:08 +0100, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>>
>> >> Hi,
>> >>
>> >> since kernel 2.6.32.2 (also tried 2.6.32.3) I get a lot of oom-killer
>> >> kills when I do hard disk intensive tasks (mainly in VirtualBox which is
>> >> running Windows XP) and IMHO it kills processes even if I have a lot of
>> >> free memory.
>> >>
>> >> Is this a known bug? I have self compiled kernel so I can try patches.
>> >
>> > Can you please post your .config?
>
> Hi all,
>
> Strangely, all reproduce machine are x86_64 with Intel i915. but I don't
> have any solid evidence.

The same oops seems to appear in an unrelated "screen going blank" bug
report (it's the second to last oops):

http://bugzilla.kernel.org/show_bug.cgi?id=15015
