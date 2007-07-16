Return-Path: <linux-kernel-owner+w=401wt.eu-S1762695AbXGPP3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762695AbXGPP3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 11:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756732AbXGPP3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 11:29:31 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:44760 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbXGPP3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 11:29:30 -0400
Date: Mon, 16 Jul 2007 17:29:45 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 3/10] sysfs: fix error handling in create_files()
Message-ID: <20070716172945.54e07c3c@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070716135230.GC2040@APFDCB5C>
References: <20070716134855.GA1858@APFDCB5C>
	<20070716135230.GC2040@APFDCB5C>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007 22:52:30 +0900,
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> Current error handling in create_files() attempts to remove
> all attributes passed by argument by remove_files(). But it should
> only remove the attributes that have been successfully added.

While this is certainly cleaner, a question out of curiousity: Does
this fix any problem you saw? sysfs_hash_and_remove() used to be safe
on non-existing attributes...
