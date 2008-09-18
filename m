Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbYIRKvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbYIRKvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 06:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYIRKvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 06:51:36 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:58864 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbYIRKvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 06:51:35 -0400
Date: Thu, 18 Sep 2008 12:50:56 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Greg K-H <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]sysfs: Don't emit a warning when sysfs_rename_link()
 fails.
Message-ID: <20080918125056.03c404e8@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <m17i99wz7k.fsf@frodo.ebiederm.org>
References: <20080917130805.6260ba9c@gondolin.boeblingen.de.ibm.com>
	<m1r67i61rh.fsf@frodo.ebiederm.org>
	<20080918090705.6985cced@gondolin.boeblingen.de.ibm.com>
	<m17i99wz7k.fsf@frodo.ebiederm.org>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008 03:00:31 -0700,
ebiederm@xmission.com (Eric W. Biederman) wrote:

> In the dev_change_name we either do dev_alloc_name
> which generates a unique device name or __dev_get_by_name
> which looks to see if we are already using that name.

Duh, I overlooked that, sorry about the noise.

(OTOH, we should get of sysfs_do_create_link() then, since it's an
unneed indirection).
