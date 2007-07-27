Return-Path: <linux-kernel-owner+w=401wt.eu-S936707AbXG0LVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936707AbXG0LVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 07:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbXG0LVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 07:21:03 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:7169 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762275AbXG0LVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 07:21:01 -0400
Date: Fri, 27 Jul 2007 13:21:15 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: mochel@osdl.org, linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] Fix kobject documentation
Message-ID: <20070727132115.45b70a5e@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <87abtijg4x.wl%takeuchi_satoru@jp.fujitsu.com>
References: <87abtijg4x.wl%takeuchi_satoru@jp.fujitsu.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007 19:27:26 +0900,
Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com> wrote:

> Fix kobject documentation as follows.
> 
>  - remove trailing spaces.
>  - struct device_subsys -> devices_subsys
> 
> Signed-off-by: Satoru Takeuchi<takeuchi_satoru@jp.fujitsu.com>

This is certainly a start, but kobject.txt needs more updates. For
example, it still refers to the removed struct subsystem, and
uevent_ops are not mentioned. Looking at kobject.h, the kerneldoc there
needs some updates as well...
