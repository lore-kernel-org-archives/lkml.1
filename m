Return-Path: <linux-kernel-owner+w=401wt.eu-S1422900AbXCOPas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422900AbXCOPas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 11:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422901AbXCOPar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 11:30:47 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:5565 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422900AbXCOPar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 11:30:47 -0400
Date: Thu, 15 Mar 2007 16:32:27 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Oliver Neukum <oneukum@suse.de>, Maneesh Soni <maneesh@in.ibm.com>,
       <gregkh@suse.de>, Richard Purdie <rpurdie@rpsys.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
Message-ID: <20070315163227.230774da@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0703150953420.13086-100000@iolanthe.rowland.org>
References: <20070315112725.7eadb7b7@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.44L0.0703150953420.13086-100000@iolanthe.rowland.org>
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

On Thu, 15 Mar 2007 10:27:19 -0400 (EDT),
Alan Stern <stern@rowland.harvard.edu> wrote:

> Fair enough.  One use of "delay" is in a comment you wrote; I'll change it 
> as well.

Fine with me.

> Would people be happier with sysfs_schedule_callback() and
> device_schedule_callback()?  At least the functions do take a callback 
> pointer as an argument, even though they aren't callbacks themselves.

Count one happy person here.
