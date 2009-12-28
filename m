Return-Path: <linux-kernel-owner+w=401wt.eu-S1751978AbZL1O7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbZL1O7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 09:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbZL1O7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 09:59:19 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:46576 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbZL1O7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 09:59:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=RiWClNb/+OH4hbQgc1xIjpPhJ5DT0ao1N1M7uvc2hOcZjzbsGecjZaMF2Ngd0u9TM1
         /vcLuQQZtoV6I4R745QgGE0k4/RSItZhEatsQDO6GMgAiJ1R8OBUyrsTukcJQvb8im7J
         FmGOW2QtixeOxJZHVtNCCV7cg/0AJHyZpQDVY=
MIME-Version: 1.0
Date: Mon, 28 Dec 2009 22:59:15 +0800
Message-ID: <b3657a100912280659oda68e2o73527ec58b35075b@mail.gmail.com>
Subject: [PATCHv3 0/3]posix_acl: add the pointer check into fs/posix_acl.c
From: liu weni <qingshenlwy@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all:
    Many filesystems have their own way to check the acl pointer, and
others not. It have something wrong while calling FOREACH_ACL_ENTRY.
Then, I wanna add a pointer check before the Macro of FOREACH_ACL_ENTRY.



---
Best Regards,
Liuwenyi
2009-12-29
