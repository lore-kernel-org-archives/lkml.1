Return-Path: <linux-kernel-owner+w=401wt.eu-S1760620AbXHHJPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620AbXHHJPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 05:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbXHHJO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 05:14:59 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:2511 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbXHHJO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 05:14:58 -0400
Date: Wed, 8 Aug 2007 11:16:00 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, satyam@infradead.org,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 0/25] Sysfs cleanups & tagged directory support
Message-ID: <20070808111600.047edd33@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <46B984D4.9020600@gmail.com>
References: <11860582832964-git-send-email-htejun@gmail.com>
	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>
	<20070808093815.0935a18e@gondolin.boeblingen.de.ibm.com>
	<m1bqdifowo.fsf@ebiederm.dsl.xmission.com>
	<20070808095432.4a520735@gondolin.boeblingen.de.ibm.com>
	<m17io6foh8.fsf@ebiederm.dsl.xmission.com>
	<20070808103759.0850383c@gondolin.boeblingen.de.ibm.com>
	<46B984D4.9020600@gmail.com>
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

On Wed, 08 Aug 2007 17:54:44 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> Are you sure it's patch 6?  Patch 17 adds a deadlock in rename path.

Yes. If I apply the series up to patch 5, everything's fine. If I apply
patch 6, /dev/dasda* is missing.
