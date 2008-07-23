Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbYGWCtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbYGWCtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 22:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYGWCsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 22:48:54 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:11094 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbYGWCsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 22:48:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LoX5hXMVYu9u+eKo60UWkwOENK47/Snn0OY7CKQ+c5QRwIcXgoTsEoijpn0/ZOjBR+
         Xmww3+ePwvq/LtvwcCb4PmqTPtmoRTswynqw3hndylI0uMDkX97AITBSVR0d7RQLJVmF
         VTh2pBESwfxAPA9qcYHEN0Lok6gPPXIStaHis=
Message-ID: <804dabb00807221948y1317633exc1a2009540b23239@mail.gmail.com>
Date: Wed, 23 Jul 2008 10:48:52 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: "Randy Dunlap" <rdunlap@xenotime.net>
Subject: Re: make htmldocs errors
Cc: KML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080722084211.10d21eb5.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <804dabb00807220407x683f0eb2we0b64821b9279e3c@mail.gmail.com>
	 <20080722084211.10d21eb5.rdunlap@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you Randy for the explanation.

Just for your interest, other tree like tracing/for-linus at:

git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git

has somewhat similar problem too (but different files altogether)...

/sda3/ftrace/tracing/for-linus>make htmldocs
  DOCPROC Documentation/DocBook/debugobjects.xml
  HTML   Documentation/DocBook/debugobjects.html
  DOCPROC Documentation/DocBook/deviceiobook.xml
  HTML   Documentation/DocBook/deviceiobook.html
  DOCPROC Documentation/DocBook/filesystems.xml
  HTML   Documentation/DocBook/filesystems.html
  DOCPROC Documentation/DocBook/gadget.xml
Error(/sda3/ftrace/tracing/for-linus//drivers/usb/gadget/config.c:132):
cannot understand prototype: 'struct usb_descriptor_header **__init
usb_copy_descriptors(struct usb_descriptor_header **src) '
Error(/sda3/ftrace/tracing/for-linus//drivers/usb/gadget/config.c:183):
cannot understand prototype: 'struct usb_endpoint_descriptor *__init
usb_find_endpoint( struct usb_descriptor_header **src,     struct
usb_descriptor_header **copy,   struct usb_endpoint_descriptor *match
) '
Warning(/sda3/ftrace/tracing/for-linus//include/linux/usb/composite.h:129):
No description found for parameter 'list'
Warning(/sda3/ftrace/tracing/for-linus//include/linux/usb/composite.h:226):
No description found for parameter 'list'
Warning(/sda3/ftrace/tracing/for-linus//include/linux/usb/composite.h:226):
No description found for parameter 'functions'
Warning(/sda3/ftrace/tracing/for-linus//include/linux/usb/composite.h:226):
No description found for parameter 'next_interface_id'
Warning(/sda3/ftrace/tracing/for-linus//include/linux/usb/composite.h:226):
No description found for parameter 'highspeed'
Warning(/sda3/ftrace/tracing/for-linus//include/linux/usb/composite.h:226):
No description found for parameter 'fullspeed'
Warning(/sda3/ftrace/tracing/for-linus//include/linux/usb/composite.h:226):
No description found for parameter 'interface[MAX_CONFIG_INTERFACES]'
Warning(/sda3/ftrace/tracing/for-linus//include/linux/usb/composite.h:322):
No description found for parameter 'desc'
Warning(/sda3/ftrace/tracing/for-linus//include/linux/usb/composite.h:322):
No description found for parameter 'configs'
Warning(/sda3/ftrace/tracing/for-linus//include/linux/usb/composite.h:322):
No description found for parameter 'driver'
Warning(/sda3/ftrace/tracing/for-linus//include/linux/usb/composite.h:322):
No description found for parameter 'next_string_id'
Warning(/sda3/ftrace/tracing/for-linus//include/linux/usb/composite.h:322):
No description found for parameter 'lock'
make[1]: *** [Documentation/DocBook/gadget.xml] Error 2
make: *** [htmldocs] Error 2

Thank you.
