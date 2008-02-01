Return-Path: <linux-kernel-owner+w=401wt.eu-S1760801AbYBALiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760801AbYBALiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 06:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757932AbYBALho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 06:37:44 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:49618 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757522AbYBALhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 06:37:43 -0500
Date: Fri, 1 Feb 2008 12:37:38 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: heiko.carstens@de.ibm.com, herbert@gondor.apana.org.au, neilb@suse.de,
       schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: crypto/async_tx/* doesn't build on s390
Message-ID: <20080201123738.24988af7@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <0C7297FA1D2D244A9C7F6959C0BF1E521D1C6C@azsmsx413.amr.corp.intel.com>
References: <0C7297FA1D2D244A9C7F6959C0BF1E521D1C6C@azsmsx413.amr.corp.intel.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008 12:49:00 -0700,
"Williams, Dan J" <dan.j.williams@intel.com> wrote:

> I am mistaken, the 'depends on ARCH...' precludes HAS_DMA.  Perhaps the compiler is emitting a call to async_tx_find_channel when it needs to be inline?  On x86 do_async_xor is successfully compiled away when CONFIG_DMA_ENGINE=n.

Just checked why it compiled for me on one box but not on the other and 
found that deactivating CONFIG_SECTION_MISMATCH makes it go away. Hmm...
