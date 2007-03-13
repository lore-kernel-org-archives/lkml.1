Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbXCMBcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbXCMBcD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 21:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbXCMBcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 21:32:03 -0400
Received: from station18k.dscga.com ([192.24.222.18]:40091 "EHLO
	suzuka.mcnaught.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbXCMBcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 21:32:01 -0400
To: Patrick Mau <mau@oscar.ping.de>
Cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org
Subject: Stracing Amanda (was: RSDL for 2.6.21-rc3- 0.29)
References: <20070311013506.GD10459@waste.org>
	<200703121428.29947.gene.heskett@gmail.com>
	<87wt1mjo4q.fsf@suzuka.mcnaught.org>
	<200703121510.18268.gene.heskett@gmail.com>
	<87slcajliq.fsf@suzuka.mcnaught.org>
	<20070312195436.GA15319@oscar.prima.de>
From: Douglas McNaught <doug@mcnaught.org>
Date: Mon, 12 Mar 2007 21:32:00 -0400
In-Reply-To: <20070312195436.GA15319@oscar.prima.de> (Patrick Mau's message
 of "Mon, 12 Mar 2007 20:54:36 +0100")
Message-ID: <874poqj5db.fsf_-_@suzuka.mcnaught.org>
User-Agent: Gnus/5.1006 (Gnus v5.10.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick Mau <mau@oscar.ping.de> writes:

> Why not temporarly replace "/bin/tar" with a shell script that does:
>
> #!/bin/sh
> exec strace -f -o output /bin/real.tar $@

You beat me to it.  :) I've done that before; it's a great suggestion.

Except that if you expect 'tar' to be invoked multiple times in a run,
you should probably use 'output.$$' for the output filename so things
don't get clobbered.

-Doug
