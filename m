Return-Path: <linux-kernel-owner+w=401wt.eu-S934230AbYEIFg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934230AbYEIFg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 01:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933484AbYEIFgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 01:36:05 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:5045 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308AbYEIFgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 01:36:01 -0400
Date: Fri, 9 May 2008 07:35:56 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Greg KH <gregkh@suse.de>, Benjamin Thery <benjamin.thery@bull.net>,
       linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>, Daniel Lezcano <dlezcano@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 10/11] avoid kobject name conflict with different
 namespaces
Message-ID: <20080509073556.3c342d14@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <m1myn0d298.fsf@frodo.ebiederm.org>
References: <20080506173030.653828076@theryb.frec.bull.fr>
	<20080506173335.922289888@theryb.frec.bull.fr>
	<m13aoueyq8.fsf@frodo.ebiederm.org>
	<20080507190838.GA4467@suse.de>
	<m1hcd9esxo.fsf@frodo.ebiederm.org>
	<20080508102844.25642ef7@gondolin.boeblingen.de.ibm.com>
	<m1myn0d298.fsf@frodo.ebiederm.org>
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

On Thu, 08 May 2008 12:28:19 -0700,
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Do you remember if we have ever sorted out the race between _move
> and module unload/directory teardown at the sysfs level?

Unfortunately I can't remember anything about this, do you have a
pointer to the original discussion?
