Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbZC1RR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbZC1RR6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 13:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZC1RRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 13:17:48 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:52785 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbZC1RRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 13:17:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=d13VTPRdnMWmCGDuw80DSjVYKndyBhzDS0jLvi7hHcQe4AmmES8cN4Ns2GKkAk4rHe
         y3Of9aUKOGChNjFAlDApqRhCQnxW20wpV2niCDmsx+aAk4CnVBGDoY8q8D1AthbghhhV
         DMf0Y/pk5MxitV35KjNbRyqPiqZK2KXpe43iE=
Message-ID: <49CE5BA6.8070109@gmail.com>
Date: Sat, 28 Mar 2009 18:17:26 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Denis Joseph Barrow <D.Barow@option.com>
CC: LKML <linux-kernel@vger.kernel.org>, eteo@redhat.com,
       Dan Carpenter <error27@gmail.com>, Alan Cox <alan@redhat.com>
Subject: Re: Dereferencing freed memory bugs
References: <a63d67fe0903240529v6a0e6b51pf67f8ad6dd6842c4@mail.gmail.com>
In-Reply-To: <a63d67fe0903240529v6a0e6b51pf67f8ad6dd6842c4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter pisze:
> I added a check to smatch (http://repo.or.cz/w/smatch.git/) to check
> for when we dereference
> freed memory.
> 
> (...)
> drivers/net/usb/hso.c +2616 hso_free_tiomget(5) 'tiocmget'

This error was added by 542f54823614915780c3459b0e6062f06c0c0f99:
tty: Modem functions for the HSO driver

Marcin

