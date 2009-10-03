Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbZJCDIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbZJCDIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 23:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbZJCDIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 23:08:19 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:44236 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbZJCDIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 23:08:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=aXfAPRkH/xp+UNGeXiCg/NiLXJ9vMDOSxjKqE6RHphOdI9J5Qtwe2XgKzy1n3VWy4q
         jv3tUY7lExURJyXf5WUAJAkqctkgGG5H7RkVBMpBxEHjT7jFmk2AWGwQGsL94jQClght
         NcJmLPhXE+jUN9jSUdJGAoSGht7HQ6d3ITrKo=
MIME-Version: 1.0
In-Reply-To: <4AC6B822.1080703@zytor.com>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com> 
	<4AC6B822.1080703@zytor.com>
From: Matteo Croce <technoboy85@gmail.com>
Date: Sat, 3 Oct 2009 05:08:02 +0200
Message-ID: <40101cc30910022008r285fed55vbd92ba8854837cf2@mail.gmail.com>
Subject: Re: i686 quirk for AMD Geode
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=00151761ca4876a82b0474ff319b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00151761ca4876a82b0474ff319b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 3, 2009 at 4:34 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/02/2009 07:12 PM, Matteo Croce wrote:
>> Hi,
>>
>> the AMD GEode LX has an x86 id of 5 (i586) tought it's technically an i6=
86:
>>
>
> a) Wrong place - it should be in cpu/amd.c.
> b) You need to also make sure that it has FCOMI and the long NOP\
> =A0 instructions.
>
> =A0 =A0 =A0 =A0-hpa
>
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel. =A0I don't speak on their behalf.
>
>

I've run the attached files and I get this:

root@alix:/usr/src# ./longnop
Long NOPs supported: no
root@alix:/usr/src# ./fcomi
Long FCOMi supported: yes

--00151761ca4876a82b0474ff319b
Content-Type: text/x-csrc; charset=US-ASCII; name="longnop.c"
Content-Disposition: attachment; filename="longnop.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g0bs86fx0

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzaWduYWwuaD4KI2luY2x1ZGUgPHNldGptcC5o
PgoKc3RhdGljIHNpZ2ptcF9idWYgb3V0OwoKdm9pZCBzaWdpbGwoaW50IHNpZ25hbCkKewogIHNp
Z2xvbmdqbXAob3V0LCAxKTsKfQoKaW50IG1haW4odm9pZCkKewogIGludCBkaWVkOwoKICBzaWdu
YWwoU0lHSUxMLCBzaWdpbGwpOwoKICBkaWVkID0gc2lnc2V0am1wKG91dCwgMSk7CgogIGlmICgh
ZGllZCkKICAgIGFzbSB2b2xhdGlsZSgibm9wbCAwKCVlYXgpIik7CgogIHByaW50ZigiTG9uZyBO
T1BzIHN1cHBvcnRlZDogJXNcbiIsIGRpZWQgPyAibm8iIDogInllcyIpOwogIHJldHVybiBkaWVk
Owp9Cg==
--00151761ca4876a82b0474ff319b
Content-Type: text/x-csrc; charset=US-ASCII; name="fcomi.c"
Content-Disposition: attachment; filename="fcomi.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g0bs8h6j1

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzaWduYWwuaD4KI2luY2x1ZGUgPHNldGptcC5o
PgoKc3RhdGljIHNpZ2ptcF9idWYgb3V0OwoKdm9pZCBzaWdpbGwoaW50IHNpZ25hbCkKewogIHNp
Z2xvbmdqbXAob3V0LCAxKTsKfQoKaW50IG1haW4odm9pZCkKewogIGludCBkaWVkOwoKICBzaWdu
YWwoU0lHSUxMLCBzaWdpbGwpOwoKICBkaWVkID0gc2lnc2V0am1wKG91dCwgMSk7CgogIGlmICgh
ZGllZCkKICAgIGFzbSB2b2xhdGlsZSgiZmNvbWkgc3QoMCksIHN0KDEpIik7CgogIHByaW50Zigi
TG9uZyBGQ09NaSBzdXBwb3J0ZWQ6ICVzXG4iLCBkaWVkID8gIm5vIiA6ICJ5ZXMiKTsKICByZXR1
cm4gZGllZDsKfQo=
--00151761ca4876a82b0474ff319b--
