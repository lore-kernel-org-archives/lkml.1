Return-Path: <linux-kernel-owner+w=401wt.eu-S1757714AbZD3Bsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714AbZD3Bsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 21:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbZD3Bsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 21:48:35 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:44849 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbZD3Bse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 21:48:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xSTD8uggR0quVTidD/w8PhQaDUe4mgrTQcBp6wmbZvAyWQu3XWIKlXyLp2SA7ZgN1R
         Jvf0UGFi3s2kAkS0UBxPJ1yyO03NTT/OGNqFirCRc26fnHo8GBp2DNZXQL8NCMJhrJcT
         KjlEiGXasDpW4eGsjnWr1grS/5HzCLlGGL2BQ=
MIME-Version: 1.0
In-Reply-To: <ac3eb2510904291745j48220c12oe2a2b91e981ea403@mail.gmail.com>
References: <20090427193532.GA2948@kroah.com>
	 <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com>
	 <20090429180735.GA29812@kroah.com>
	 <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com>
	 <20090429183012.GA28237@kroah.com>
	 <8bd0f97a0904291638p398ad701j5dc0f8e96de2fb47@mail.gmail.com>
	 <ac3eb2510904291745j48220c12oe2a2b91e981ea403@mail.gmail.com>
Date: Wed, 29 Apr 2009 21:48:33 -0400
Message-ID: <8bd0f97a0904291848le808891kff973b1677b7cd33@mail.gmail.com>
Subject: Re: usbutils 0.81 release
From: Mike Frysinger <vapier.adi@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=001e680f17accc59760468bbe49b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001e680f17accc59760468bbe49b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On Wed, Apr 29, 2009 at 20:45, Kay Sievers wrote:
> On Thu, Apr 30, 2009 at 01:38, Mike Frysinger wrote:
>> On Wed, Apr 29, 2009 at 14:30, Greg KH wrote:
>>> On Wed, Apr 29, 2009 at 02:17:12PM -0400, Mike Frysinger wrote:
>>>> >> find being able to run `usbmodules` pretty useful ... i wrote a script
>>>> >> for fun:
>>>> >> http://sources.gentoo.org/sys-apps/usbutils/files/usbmodules.sh
>>>> >
>>>> > Did that work on any 2.6 kernel?
>>>>
>>>> it's the only version ive tested it with ... but it doesnt parse any
>>>> kernel module directly, it reads the generated modules.usbmap file
>>>>
>>>> > There's no reason we can't add "-k" support to lsusb like lspci has to
>>>> > show the modules assigned to different devices.
>>>>
>>>> the method i posted above only needs the module to be compiled, not loaded
>>>
>>> As the map files are depreciated, I wouldn't continue to rely on it, it
>>> will break in the future when the kernel stops generating those files.
>>
>> guess i'll have to rewrite it to parse the .ko modules directly like
>> the usbmap is generated now
>
> Can't you use the modules.aliases file? That should stay around and
> there should be the same information contained.

should be fine if it's going to be sticking around

any comments on the attached file ?  in theory, it could be easily
extended for pci and other busses ...
-mike

--001e680f17accc59760468bbe49b
Content-Type: application/x-sh; name="usbmodules.sh"
Content-Disposition: attachment; filename="usbmodules.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fu4sr7uu0

IyEvYmluL3NoCgplcnIoKSB7IGVjaG8gInVzYm1vZHVsZXM6IGVycm9yOiAkKiIgMT4mMiA7IH0K
CnVzYWdlKCkgewoJY2F0IDw8LUVPRgoJTGlzdCByZWxldmFudCBrZXJuZWwgbW9kdWxlcyBmb3Ig
VVNCIGRldmljZXMgY3VycmVudGx5IHBsdWdnZWQgaW4uICBUaGUKCW1vZHVsZSBsaXN0IGlzIHRh
a2VuIGZyb20gdGhlIG1vZHVsZXMgaW5zdGFsbGVkIGluIC9saWIvbW9kdWxlcy88dmVyPi8uCgoJ
VXNhZ2U6IHVzYm1vZHVsZXMgW29wdGlvbnNdIFtrZXJuZWwgdmVyc2lvbl0KCglPcHRpb25zOgoJ
ICAtbSwgLS1tYXAgPG1hcD4gICBTcGVjaWZ5IHVzYm1hcCAoZGVmYXVsdDogL2xpYi9tb2R1bGVz
Lzx2ZXI+L21vZHVsZXMudXNibWFwKQoJICAtaCwgLS1oZWxwICAgICAgICBUaGlzIGhlbHAgc2Ny
ZWVuCglFT0YKCWlmIFsgLW4gIiQqIiBdIDsgdGhlbgoJCWVyciAiJCoiCgkJZXhpdCAxCgllbHNl
CgkJZXhpdCAwCglmaQp9CgptYXA9IiIKCndoaWxlIFsgLW4gIiQxIiBdIDsgZG8KCWNhc2UgJDEg
aW4KCQktbXwtLW1hcCkgIG1hcD0kMjsgc2hpZnQ7OwoJCS1ofC0taGVscCkgdXNhZ2U7OwoJCS0t
KSAgICAgICAgYnJlYWs7OwoJCS0qKSAgICAgICAgdXNhZ2UgInVua25vd24gb3B0aW9uICckMSci
OzsKCQkqKSAgICAgICAgIGJyZWFrOzsKCWVzYWMKCXNoaWZ0CmRvbmUKCnZlcj0kezE6LSQodW5h
bWUgLXIpfQptYXA9JHttYXA6LS9saWIvbW9kdWxlcy8ke3Zlcn0vbW9kdWxlcy51c2JtYXB9Cgpp
ZiBbICEgLXIgIiR7bWFwfSIgXSA7IHRoZW4KCWVyciAidW5hYmxlIHRvIHJlYWQgbWFwIGZpbGU6
ICR7bWFwfSIKCWV4aXQgMQpmaQoKZm9yIGRldiBpbiAkKGxzdXNiIHwgYXdrICd7cHJpbnQgJDZ9
JykgOyBkbwoJWyAiJHtkZXZ9IiA9ICIwMDAwOjAwMDAiIF0gJiYgY29udGludWUKCglJRlM9OgoJ
c2V0IC0tICR7ZGV2fQoJdmVuZG9yPSQxCglwcm9kdWN0PSQyCgl1bnNldCBJRlMKCglhbGlhcz0i
dXNiOnYke3ZlbmRvcn1wJHtwcm9kdWN0fSIKCWF3ayAnJDEgPT0gImFsaWFzIiAmJiAkMiB+IC9e
JyR7YWxpYXN9Jy8ge3ByaW50ICRORn0nICR7bWFwfQpkb25lCgpleGl0IDAK
--001e680f17accc59760468bbe49b--
