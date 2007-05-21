Return-Path: <linux-kernel-owner+w=401wt.eu-S1760426AbXEUMAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760426AbXEUMAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 08:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755714AbXEUMA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 08:00:29 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:42711 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbXEUMA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 08:00:27 -0400
Date: Mon, 21 May 2007 14:00:25 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: Re: [patch 1/5] cio: Update documentation.
Message-ID: <20070521140025.7b9344a5@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070521115322.GB15143@infradead.org>
References: <20070521105118.955425052@de.ibm.com>
	<20070521110108.214724333@de.ibm.com>
	<20070521115322.GB15143@infradead.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007 12:53:22 +0100,
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, May 21, 2007 at 12:51:19PM +0200, Martin Schwidefsky wrote:
> > From: Cornelia Huck <cornelia.huck@de.ibm.com>
> > 
> > - read_dev_chars()/read_conf_data() are deprecated. Don't document them, but
> >   advise to issue the channel program from the driver itself.
> 
> What's the reason these function aren't just removed?  They're just unused
> bloat right now.

They had been a documented and exported interface for ages, and I
didn't feel like breaking external modules without some warning
beforehand.
