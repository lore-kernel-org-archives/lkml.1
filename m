Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbYJTWXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbYJTWXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 18:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbYJTWWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 18:22:55 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:59556 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbYJTWWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 18:22:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=uIc3SquZHBujTZ0wJTTOal/9KcyZz0z3JGzaGY3w28MMIy10lrahnwuf6JjqEJspWG
         rXn+YCh8BixwCxI1SOv+k7ml7UrdrtcUyqf4bxVtMKz+UKe8obfIhKWrww+XFYBPwIDp
         +DCeJiEdSF4OB537WZT+uAkZHHs8G9/iI3xkQ=
Message-ID: <ed82fe3e0810201522g63649e97uf162e894a19de23a@mail.gmail.com>
Date: Mon, 20 Oct 2008 17:22:53 -0500
From: "Timur Tabi" <timur@freescale.com>
To: linux-kernel@vger.kernel.org
Subject: call_usermodehelper_exec() hangs in call to queue_work()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 3f3af8bc3b35130a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm updating my driver to use kobjects so that I can call uevents.
I've never used any of these calls before, so I'm sure I'm doing
something stupid, but I need help.

I'm creating one kset and three kobjects.  I call kobject_uevent after
calling kobject_init_and_add().  The second time I call
kobject_uevent(), the kernel hangs when call_usermodehelper_exec()
calls queue_work().  I haven't been able to trace the code past that
yet.

Does anyone have any idea what I'm doing wrong?  I'm hoping this is a
common problem.

-- 
Timur Tabi
Linux kernel developer at Freescale
