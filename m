Return-Path: <linux-kernel-owner+w=401wt.eu-S2992715AbXDRPER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992715AbXDRPER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 11:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992716AbXDRPER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 11:04:17 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:36682 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992715AbXDRPER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 11:04:17 -0400
Date: Wed, 18 Apr 2007 17:06:52 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>, dmitry.torokhov@gmail.com
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
Message-ID: <20070418170652.7bee0952@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070417184110.GJ10619@htj.dyndns.org>
References: <20070416193619.4659a847@gondolin.boeblingen.de.ibm.com>
	<20070417184110.GJ10619@htj.dyndns.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007 03:41:10 +0900,
Tejun Heo <htejun@gmail.com> wrote:

<patch>

OK, I hit a bit on the code. Once I saved a reference to the completion
in kobject_cleanup, it seemed to survive a load/unload testloop for a
module registering a device. However, I still dislike this "list of
waiters" approach, it looks too complex...

