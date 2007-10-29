Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbXJ2PbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbXJ2PbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbXJ2Pa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:30:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbXJ2Pa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:30:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071029152447.GP7227@stusta.de>
References: <20071029152447.GP7227@stusta.de> <20071027141957.GY30533@stusta.de> <3357.1193662826@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fs/afs/vlocation.c: fix off-by-one
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 29 Oct 2007 15:30:47 +0000
Message-ID: <16357.1193671847@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> wrote:

> Check the last line of the patch I sent:
>   if (vl->vldb.name[namesz] != '\0')

Seems I forgotten some of what my own code does:-)

Actually, you're right.  I added in a gap for the NUL.  Okay, I retract my
NAK.  Consider it ACK'd instead.

David
