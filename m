Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbYHQTod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbYHQTod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755099AbYHQTmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:42:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:56804 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973AbYHQTmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:42:21 -0400
Date: Sun, 17 Aug 2008 12:42:12 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Marc Villemade" <mastachand@gmail.com>
Cc: "Rik van Riel" <riel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [Follow-up] Physical memory disappeared from /proc/meminfo
Message-ID: <20080817124212.6048fa71@infradead.org>
In-Reply-To: <f2b895370808171226l13728b1dg7e79051c158e21f3@mail.gmail.com>
References: <f2b895370808171059x4bd0296frf50b07ae7af21375@mail.gmail.com>
	<20080817145906.06ccd795@riellaptop.surriel.com>
	<f2b895370808171226l13728b1dg7e79051c158e21f3@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Aug 2008 21:26:07 +0200
"Marc Villemade" <mastachand@gmail.com> wrote:

> hey
> 
> Thanks for your answer, but it still doesn't come close. I'm up to 1.5
> Gig adding what i said. and PageTables + VMallocTotal equals 160 Mo.
> Sounds unlikely to me that something unaccounted for might go up to
> 1.4 Gig, don't you think ? Or maybe it is accounted somewhere else
> than /proc/meminfo ? Please point me to the right place if so.
> 

you're not accidentally using shmfs or tmpfs are you ?
(or otherwise have a leak in sysv shm)


you can use the "ipcs" command to see your shm allocation

(and for tmpfs/shmfs... check if you have it mounted anywhere.
Something like /dev being on shmfs and /dev/null being a file not a
device can.. totally screw you over)
