Return-Path: <linux-kernel-owner+w=401wt.eu-S1759305AbYENL1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305AbYENL1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 07:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760087AbYENL0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 07:26:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821AbYENL0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 07:26:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1210619134.24092.51.camel@brick>
References: <1210619134.24092.51.camel@brick>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide <linux-ide@vger.kernel.org>,
       linux-netdev <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>, Jeff Garzik <jeff@garzik.org>,
       Ingo Molnar <mingo@elte.hu>, Jason Wessel <jason.wessel@windriver.com>,
       "ralf@linux-mips.org" <ralf@linux-mips.org>,
       Paul Mundt <lethal@linux-sh.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 01/12] lib: create common ascii hex array
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 14 May 2008 12:26:10 +0100
Message-ID: <1507.1210764370@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Add a common hex array in hexdump.c so everyone can use it.
> 
> Add a common hi/lo helper to avoid the shifting masking that is
> done to get the upper and lower nibbles of a byte value.
> 
> Pull the pack_hex_byte helper from kgdb as it is opencoded many
> places in the tree that will be consolidated.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Acked-by: David Howells <dhowells@redhat.com>
