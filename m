Return-Path: <linux-kernel-owner+w=401wt.eu-S1762428AbXGVSlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762428AbXGVSlr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 14:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757922AbXGVSlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 14:41:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:13262 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482AbXGVSlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 14:41:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Ktd5QcmNiGQWRCOKn4S6zM4F+yOlmCEfsmGwLlJy0ajmvzznM17zuTTEBgOm/pjVMV8tTHgzQlFhHo1kvIjXKvNsb2/sgiHTjVkntn33dZyVxsSiPcNCxkzEnHJnjdk4o1HCWNVwKnCxeuxYB3xHrhhojgjihNk6l6YPF57LrSk=
Message-ID: <92a12cdb0707221141i4398d6fdxa7994c5f1f809b0a@mail.gmail.com>
Date: Sun, 22 Jul 2007 19:41:39 +0100
From: "Adrian McMenamin" <adrianmcmenamin@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Problems with framebuffer in 2.6.22-git17
Cc: lethal@users.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I ma having problems with the pvr2 fb on the Dreamcast in 2.6.22-git17
- when the code is executed it appears to lock the Dreamcast up.

The problem seems to be:

 fb_notifier_call_chain(FB_EVENT_FB_REGISTERED, &event);

In drivers/video/fbmem.c

This hasn't been an issue before, so are there any recent changes that
might have caused this?

(fb_notifier_call_chain calls a succession of stubs ending in
__blocking_notifier_call_chain in kernel/sys.c)

Adrian
