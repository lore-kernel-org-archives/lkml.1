Return-Path: <linux-kernel-owner+w=401wt.eu-S1760161AbZEHGk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760161AbZEHGk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 02:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759340AbZEHGkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 02:40:47 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:34283 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbZEHGkq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 02:40:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b0SEVq3kqpztRICosEp+3qf5zypiVC2olI26F+17yhDbOhnbWdrKy8DdS0KyoAj7o+
         +9mv0wIartg+7MtAv57ZwBOvu7CSTPVyGMGsRu2Xcon2VJwM911MXTCkz1ddSR8sETEz
         CvJQzHfVTEVD/F5vBEe7RRiPgQInr7eozAxFc=
MIME-Version: 1.0
In-Reply-To: <20090508040101.GC31689@kroah.com>
References: <20090506222439.GB22327@kroah.com>
	 <a276da400905070451j550d9a9ajcdd3ab30b03278aa@mail.gmail.com>
	 <20090508040101.GC31689@kroah.com>
Date: Fri, 8 May 2009 14:40:45 +0800
Message-ID: <a276da400905072340j6130615bu3ef524be5bd48143@mail.gmail.com>
Subject: Re: usbutils 0.82 release
From: Xiaofan Chen <xiaofanc@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 8, 2009 at 12:01 PM, Greg KH <greg@kroah.com> wrote:
> On Thu, May 07, 2009 at 07:51:23PM +0800, Xiaofan Chen wrote:
>> Not sure if this is a real problem or not. There is a compiler warning
>> for gcc 4.4.0.
>>
>> gcc -DHAVE_CONFIG_H -I.   -DDATADIR=\"/usr/share\"   -g -O2 -MT
>> lsusb-names.o -MD -MP -MF .deps/lsusb-names.Tpo -c -o lsusb-names.o
>> `test -f 'names.c' || echo './'`names.c
>> names.c: In function ‘names_init’:
>> names.c:803: warning: assignment makes pointer from integer without a cast
>
> Care to provide a patch for this?

To be honest, I do not know the reason of the warning. It looks fine to me
but I am not a real programmer.

In fact, I tried version 0.73 and there is no warning there and the file name.c
is the same between 0.73 and 0.81/0.82.

For 0.73:
[mcuee@myhost usbutils-0.73]$ make
make  all-am
make[1]: Entering directory `/home/mcuee/Desktop/build/usbutils/usbutils-0.73'
if gcc -DHAVE_CONFIG_H -I. -I. -I.  -DUSBIDS_DIR='"/usr/local/share"'
-Wall -W -Wunused -g -O2 -MT lsusb.o -MD -MP -MF ".deps/lsusb.Tpo" -c
-o lsusb.o lsusb.c; \
	then mv -f ".deps/lsusb.Tpo" ".deps/lsusb.Po"; else rm -f
".deps/lsusb.Tpo"; exit 1; fi
lsusb.c: In function ‘do_wireless’:
lsusb.c:2648: warning: unused parameter ‘fd’
if gcc -DHAVE_CONFIG_H -I. -I. -I.  -DUSBIDS_DIR='"/usr/local/share"'
-Wall -W -Wunused -g -O2 -MT names.o -MD -MP -MF ".deps/names.Tpo" -c
-o names.o names.c; \
	then mv -f ".deps/names.Tpo" ".deps/names.Po"; else rm -f
".deps/names.Tpo"; exit 1; fi
if gcc -DHAVE_CONFIG_H -I. -I. -I.  -DUSBIDS_DIR='"/usr/local/share"'
-Wall -W -Wunused -g -O2 -MT devtree.o -MD -MP -MF ".deps/devtree.Tpo"
-c -o devtree.o devtree.c; \
	then mv -f ".deps/devtree.Tpo" ".deps/devtree.Po"; else rm -f
".deps/devtree.Tpo"; exit 1; fi
if gcc -DHAVE_CONFIG_H -I. -I. -I.  -DUSBIDS_DIR='"/usr/local/share"'
-Wall -W -Wunused -g -O2 -MT usbmisc.o -MD -MP -MF ".deps/usbmisc.Tpo"
-c -o usbmisc.o usbmisc.c; \
	then mv -f ".deps/usbmisc.Tpo" ".deps/usbmisc.Po"; else rm -f
".deps/usbmisc.Tpo"; exit 1; fi
gcc -Wall -W -Wunused -g -O2   -o lsusb  lsusb.o names.o devtree.o
usbmisc.o  -lz -lusb
make[1]: Leaving directory `/home/mcuee/Desktop/build/usbutils/usbutils-0.73'


-- 
Xiaofan http://mcuee.blogspot.com
