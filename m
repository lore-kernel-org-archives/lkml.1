Return-Path: <linux-kernel-owner+w=401wt.eu-S1753696AbYIUXQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbYIUXQw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 19:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYIUXQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 19:16:43 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:1848 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbYIUXQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 19:16:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=R8yV1jPTzUkW+FrTPg8ivlIUd0vVmeOYTSnqhxL8TabqXaB3U7Tov1dUWHgr4f8lbo
         uWGOYc67xvzEfF9XAJp8p3y25f0uaq9p7NBkeAabjQq4xz6emZeanUKmBdrnx0WY8Dj8
         w/6M2SEryD1pDV9wZRlNjMYFo3p35/nhZJ7L0=
Message-ID: <dd18b0c30809211616g658b50c8k2ea9f9953f1de96f@mail.gmail.com>
Date: Sun, 21 Sep 2008 16:16:42 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11552] Disabling IRQ #23
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "David Brownell" <david-b@pacbell.net>
In-Reply-To: <7lIhZC4hCxE.A.vqG.X0q1IB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <PJz8fNrJNHG.A.65F.wzq1IB@albercik>
	 <7lIhZC4hCxE.A.vqG.X0q1IB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2008 at 11:54 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=11552
> Subject         : Disabling IRQ #23
> Submitter       : Justin Mattock <justinmattock@gmail.com>
> Date            : 2008-09-09 19:08 (13 days old)
> References      : http://marc.info/?l=linux-kernel&m=122098735230906&w=4
>                  http://marc.info/?l=linux-kernel&m=122107367715361&w=4
> Handled-By      : David Brownell <david-b@pacbell.net>
>                  Alan Stern <stern@rowland.harvard.edu>
> Patch           : http://marc.info/?l=linux-kernel&m=122187222705195&w=4
>
>
>

not sure if it should be;
>From over here, I did a bad install
of isight-firmware-tools, causing hal and udev
to clash.  After making sure the package was either
using hal or udev, there is no message of disable irq #23.
If its not too much trouble is there a way to verify that this was
the case, i.g. if udev creates a dev, then hal creates the same device
will this cause ehci_hcd to have messages of this kind? If so
then thats what happened, if not then theres something else causing this.

-- 
Justin P. Mattock
