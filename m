Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbZG0C1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbZG0C1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 22:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZG0C1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 22:27:45 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:39769 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbZG0C1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 22:27:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pAkq+vNJCQFRJC2BdYUrQPRGAQ3u4p4HbYbnPVczh7m/cbAK3kBl0vkG/phTv/7jjR
         dFP5EmzqCdZdLr8R4OqTPfHBTjc8LNjtGvcjQ343qlU4RkTeoiKSN0nrjnAZogLxAQi3
         cMtBZeR8+oP+qrfc3s0SHMaWkVl8lse1IUvn4=
Date: Mon, 27 Jul 2009 04:26:23 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Ferenc Wagner <wferi@niif.hu>,
       Kay Sievers <kay.sievers@vrfy.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [Bisected] [Bug #13821] Replugging USB serial converter uses new
	device node
Message-ID: <20090727022623.GA6614@Pilar.aei.mpg.de>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.p7C.WHObKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3zAHs5O6maO.A.p7C.WHObKB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 26.Jul'09 at 22:28:27 +0200, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13821
> Subject		: Replugging USB serial converter uses new device node
> Submitter	: Ferenc Wagner <wferi@niif.hu>
> Date		: 2009-07-18 20:04 (9 days old)
> References	: http://marc.info/?l=linux-kernel&m=124794754015776&w=4

I was scanning the regressions list and noticed that I could reproduce
this bug.

So I bisected it to commit 335f8514f200e63d689113d29cb7253a5c282967
("tty: Bring the usb tty port structure into more use"), from Alan
Cox.

I did not double check if reverting it from -rc4 fixes the issue,
but I noticed that this patch touches drivers/usb/serial/option.c, which
is the driver I used to test this problem.

If there is anything else I can do (give more info, test patches etc),
please let me know.
