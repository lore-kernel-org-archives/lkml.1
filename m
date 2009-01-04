Return-Path: <linux-kernel-owner+w=401wt.eu-S1760807AbZADTx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760807AbZADTx2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 14:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760329AbZADTxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 14:53:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760221AbZADTxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 14:53:00 -0500
Date: Sun, 4 Jan 2009 11:52:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, mingo@elte.hu, fweisbec@gmail.com,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/4] fastboot: Asynchronous function calls to speed up
 kernel boot
Message-Id: <20090104115216.db746414.akpm@linux-foundation.org>
In-Reply-To: <20090104194946.GB496@one.firstfloor.org>
References: <20090104092430.7ffd2c41@infradead.org>
	<20090104092857.5fbf6b2d@infradead.org>
	<87k59aops9.fsf@basil.nowhere.org>
	<20090104110932.6563cc6d@infradead.org>
	<20090104194946.GB496@one.firstfloor.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2009 20:49:46 +0100 Andi Kleen <andi@firstfloor.org> wrote:

> > 
> > > and this
> > > is just another variant that except for the sequence stuff
> > > isn't all that much different. So it would be better to have 
> > > a generic worker thread manager that just supports these
> > > barriers too.
> > 
> > ... or maybe think about seeing this system as exactly that thread
> > manager?
> 
> I'm not sure it's generic enough.

There's appreciable overlap with David Howells's "slow work" thread
pool thingy. If either of those was generic enough, the other would
go away.
