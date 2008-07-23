Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbYGWDXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbYGWDXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 23:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbYGWDXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 23:23:39 -0400
Received: from xenotime.net ([66.160.160.81]:47923 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753101AbYGWDXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 23:23:39 -0400
Date: Tue, 22 Jul 2008 20:23:36 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Peter Teoh" <htmldeveloper@gmail.com>
Cc: KML <linux-kernel@vger.kernel.org>
Subject: Re: make htmldocs errors
Message-Id: <20080722202336.f056a5fe.rdunlap@xenotime.net>
In-Reply-To: <804dabb00807221948y1317633exc1a2009540b23239@mail.gmail.com>
References: <804dabb00807220407x683f0eb2we0b64821b9279e3c@mail.gmail.com>
	<20080722084211.10d21eb5.rdunlap@xenotime.net>
	<804dabb00807221948y1317633exc1a2009540b23239@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2008 10:48:52 +0800 Peter Teoh wrote:

> Thank you Randy for the explanation.
> 
> Just for your interest, other tree like tracing/for-linus at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git

AFAIAC, one person cannot fix _all_ git trees.  There are at least
200 kernel git trees at git.kernel.org (probably lots of them are defunct).
It just doesn't scale IMHO, so please send patches after you confirm that
patches are indeed needed.


> has somewhat similar problem too (but different files altogether)...
> 
> /sda3/ftrace/tracing/for-linus>make htmldocs
>   DOCPROC Documentation/DocBook/debugobjects.xml
>   HTML   Documentation/DocBook/debugobjects.html
>   DOCPROC Documentation/DocBook/deviceiobook.xml
>   HTML   Documentation/DocBook/deviceiobook.html
>   DOCPROC Documentation/DocBook/filesystems.xml
>   HTML   Documentation/DocBook/filesystems.html
>   DOCPROC Documentation/DocBook/gadget.xml
> Error(/sda3/ftrace/tracing/for-linus//drivers/usb/gadget/config.c:132):
> cannot understand prototype: 'struct usb_descriptor_header **__init
> usb_copy_descriptors(struct usb_descriptor_header **src) '
> Error(/sda3/ftrace/tracing/for-linus//drivers/usb/gadget/config.c:183):
> cannot understand prototype: 'struct usb_endpoint_descriptor *__init
> usb_find_endpoint( struct usb_descriptor_header **src,     struct
> usb_descriptor_header **copy,   struct usb_endpoint_descriptor *match
> ) '

Fix for above is in the kbuild tree and I have ask that it be merged Soon.
Otherwise I'll need to merge it separately.

> Warning(/sda3/ftrace/tracing/for-linus//include/linux/usb/composite.h:129):
> No description found for parameter 'list'
> Warning(/sda3/ftrace/tracing/for-linus//include/linux/usb/composite.h:226):
> No description found for parameter 'list'
> Warning(/sda3/ftrace/tracing/for-linus//include/linux/usb/composite.h:226):
> No description found for parameter 'functions'
> Warning(/sda3/ftrace/tracing/for-linus//include/linux/usb/composite.h:226):
> No description found for parameter 'next_interface_id'
> Warning(/sda3/ftrace/tracing/for-linus//include/linux/usb/composite.h:226):
> No description found for parameter 'highspeed'
> Warning(/sda3/ftrace/tracing/for-linus//include/linux/usb/composite.h:226):
> No description found for parameter 'fullspeed'
> Warning(/sda3/ftrace/tracing/for-linus//include/linux/usb/composite.h:226):
> No description found for parameter 'interface[MAX_CONFIG_INTERFACES]'
> Warning(/sda3/ftrace/tracing/for-linus//include/linux/usb/composite.h:322):
> No description found for parameter 'desc'
> Warning(/sda3/ftrace/tracing/for-linus//include/linux/usb/composite.h:322):
> No description found for parameter 'configs'
> Warning(/sda3/ftrace/tracing/for-linus//include/linux/usb/composite.h:322):
> No description found for parameter 'driver'
> Warning(/sda3/ftrace/tracing/for-linus//include/linux/usb/composite.h:322):
> No description found for parameter 'next_string_id'
> Warning(/sda3/ftrace/tracing/for-linus//include/linux/usb/composite.h:322):
> No description found for parameter 'lock'

I've already sent that list to the linux-usb mailing list...

I mainly try to focus on the fatal errors or changes that need to be made
to scripts/kernel-doc.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
