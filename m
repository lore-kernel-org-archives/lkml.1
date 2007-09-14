Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbXINLDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbXINLDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 07:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758178AbXINLDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 07:03:34 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:20275 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757132AbXINLDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 07:03:32 -0400
Date: Fri, 14 Sep 2007 13:03:31 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Driver core: remove put_bus()
Message-ID: <20070914130331.0df41c42@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070913233947.GD10856@kroah.com>
References: <20070913233751.GA10856@kroah.com>
	<20070913233947.GD10856@kroah.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007 16:39:47 -0700,
Greg KH <greg@kroah.com> wrote:

> put_bus() should not be globally visable as it is not used by anything
> other than drivers/base/bus.c.  This patch removes the visability of it,
> and renames it to match all of the other *_put() functions in the
> kernel.

Same comment as for get_bus(): There's put_device() and put_driver().
