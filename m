Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbYIKSec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbYIKSec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 14:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbYIKSeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 14:34:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61334 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbYIKSeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 14:34:23 -0400
Date: 11 Sep 2008 20:30:00 +0200
From: lirc@bartelmus.de (Christoph Bartelmus)
To: jwilson@redhat.com
Cc: j@jannau.net
Cc: linux-kernel@vger.kernel.org
Cc: lkml@ml.breakpoint.cc
Cc: superm1@ubuntu.com
Message-ID: <AlfDffi3jFB@christoph>
In-Reply-To: <200809091303.27742.jwilson@redhat.com>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
User-Agent: OpenXP/4.10.7369 (Linux) (i386)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX19wzQdCYx4LvqmHUcKoSkYyfjjfvQsshi0aeFx
 daUty0MEOXewkytL9YbYkgGDTieWKl0wrnfU12YB+cTUbjIU1n
 c4cOnqiJDWPipOpWNUV6L9/BjjvVuCr7F5BZ0PIXKc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

on 09 Sep 08 at 13:03, Jarod Wilson wrote:
> On Tuesday 09 September 2008 03:40:18 Sebastian Siewior wrote:
[...]
>>>+EXTRA_CFLAGS =-DIRCTL_DEV_MAJOR=61 -DLIRC_SERIAL_TRANSMITTER -I$(src)
>>
>> Do you rely on this specific major? Since your daemon opens /dev/lirc0
>> you don't need a fixed major do you?

> Good question. Quite honestly, I'm not sure. Christoph?

LIRC does not rely on a specific major. But to be honest, the last time I  
looked into this issue, was when devfs was bleeding-edge...

So, we need some advice here how to proceed. Should we try to register an  
official major number for LIRC? Should we try to have a minor number  
mapping, e.g.
/dev/lirc/serial/0 LIRC device on 1st UART serial port
...
/dev/lirc/serial/n LIRC device on n-th UART serial port
/dev/lirc/parallel/0 LIRC device on 1st parallel port
...
/dev/lirc/parallel/n LIRC device on n-th parallel port
/dev/lirc/usb/0 1st LIRC USB device
...

Christoph
