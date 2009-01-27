Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbZA0IpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbZA0IpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 03:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbZA0Io4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 03:44:56 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:10825 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbZA0Io4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 03:44:56 -0500
Date: Tue, 27 Jan 2009 09:44:45 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Rufus & Azrael <rufus-azrael@numericable.fr>
Cc: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Takashi Iwai <tiwai@suse.de>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: [2.6.29-rc2-git2] compilation warnings
Message-ID: <20090127094445.010c4305@hyperion.delvare>
In-Reply-To: <497EB491.6080904@numericable.fr>
References: <497EB491.6080904@numericable.fr>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009 08:15:29 +0100, Rufus & Azrael wrote:
> Hi all,

First of all: you really DO NOT WANT to send a message to 4000 people
asking for an acknowledgment of receipt.

> Here are my compilation warnings for fresh 2.6.29-rc2-git2 kernel :

Sending 33k of warning messages at once to a generic mailing list is
unlikely to get you anywhere. If you really want these warnings to get
fixed, you better find the right person to report each warning.
Otherwise your report has very little value.

> > drivers/i2c/i2c-core.c: In function ‘i2c_new_device’:
> > drivers/i2c/i2c-core.c:283: attention : ‘i2c_attach_client’ is 
> > deprecated (declared at include/linux/i2c.h:434)
> > drivers/i2c/i2c-core.c: In function ‘i2c_del_adapter’:
> > drivers/i2c/i2c-core.c:646: attention : ‘detach_client’ is deprecated 
> > (declared at include/linux/i2c.h:154)
> > drivers/i2c/i2c-core.c: In function ‘i2c_register_driver’:
> > drivers/i2c/i2c-core.c:713: attention : ‘detach_client’ is deprecated 
> > (declared at include/linux/i2c.h:154)
> > drivers/i2c/i2c-core.c: In function ‘__detach_adapter’:
> > drivers/i2c/i2c-core.c:780: attention : ‘detach_client’ is deprecated 
> > (declared at include/linux/i2c.h:154)
> > drivers/i2c/i2c-core.c: Hors de toute fonction :
> > drivers/i2c/i2c-core.c:876: attention : ‘i2c_attach_client’ is 
> > deprecated (declared at drivers/i2c/i2c-core.c:827)
> > drivers/i2c/i2c-core.c:876: attention : ‘i2c_attach_client’ is 
> > deprecated (declared at drivers/i2c/i2c-core.c:827)
> > drivers/i2c/i2c-core.c:904: attention : ‘i2c_detach_client’ is 
> > deprecated (declared at drivers/i2c/i2c-core.c:879)
> > drivers/i2c/i2c-core.c:904: attention : ‘i2c_detach_client’ is 
> > deprecated (declared at drivers/i2c/i2c-core.c:879)

Deprecation warnings are aimed at other developers, users can ignore
them safely. They will go away as soon as the deprecated symbols are no
longer used.

-- 
Jean Delvare
