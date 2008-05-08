Return-Path: <linux-kernel-owner+w=401wt.eu-S1758285AbYEHI3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285AbYEHI3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 04:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbYEHI24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 04:28:56 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:6522 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbYEHI2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 04:28:54 -0400
Date: Thu, 8 May 2008 10:28:44 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Greg KH <gregkh@suse.de>, Benjamin Thery <benjamin.thery@bull.net>,
       linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>, Daniel Lezcano <dlezcano@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 10/11] avoid kobject name conflict with different
 namespaces
Message-ID: <20080508102844.25642ef7@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <m1hcd9esxo.fsf@frodo.ebiederm.org>
References: <20080506173030.653828076@theryb.frec.bull.fr>
	<20080506173335.922289888@theryb.frec.bull.fr>
	<m13aoueyq8.fsf@frodo.ebiederm.org>
	<20080507190838.GA4467@suse.de>
	<m1hcd9esxo.fsf@frodo.ebiederm.org>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2008 13:54:27 -0700,
ebiederm@xmission.com (Eric W. Biederman) wrote:

> > I thought that s390 also used it, but I don't see
> > that usage in the tree anymore, perhaps they switched to something else.
> 
> That is the device_move -> kobject_move case. 

Yes. bluetooth also uses it, IIRC.

> Very similar (and nice
> if we can figure out how to combine them).

Sounds like a good idea. I can test the _move() stuff (after I've
managed to find some time to try this patchset...)
