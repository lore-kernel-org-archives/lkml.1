Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463Ab0AEFi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab0AEFi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 00:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612Ab0AEFi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 00:38:57 -0500
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:37646 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750888Ab0AEFi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 00:38:56 -0500
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <201001050538.o055c5eF021739@turbo.physics.adelaide.edu.au>
Subject: Re: 2.9.29.2: ide-tape: panic when probing device at boot
To: petkovbb@googlemail.com (Borislav Petkov)
Date: Tue, 5 Jan 2010 16:08:04 +1030 (CST)
Cc: hancockrwd@gmail.com, jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       tj@kernel.org (Tejun Heo),
       bzolnier@gmail.com (Bartlomiej Zolnierkiewicz),
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20100104054740.GA10094@liondog.tnic> from "Borislav Petkov" at Jan 04, 2010 06:47:40 AM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Jan 04, 2010 at 11:45:12AM +1030, Jonathan Woithe wrote:
> > Has there been any movement on this in recent months?  I gave 2.6.30 a whirl
> > on the machine when that was released but it still gave major problems with
> > the ide-tape driver.  Is 2.6.32 likely to be improved?  If so I'll make
> > arrangements to test that version.
> 
> Yes, please do test 2.6.32 to see whether it fixes your problem. If you still
> get that oops, please apply the following patch and send me the _whole_ dmesg
> output of the machine.

Ok, will do.  Since it is a production machine and I've got linux.conf.au
coming up it may be a couple of weeks before I get to do the test.  I'll
advise the outcome once I have tested it.

Robert Hancock wrote:
> You could also try using libata instead of IDE drivers and see if they 
> work any better for you..

Yes, a good suggestion (I'm not sure why I neglected to try that initially). 
I'll test that too and report back.

Regards
  jonathan
