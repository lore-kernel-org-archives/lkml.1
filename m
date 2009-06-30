Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbZF3Taz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbZF3Taz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 15:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbZF3Tar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 15:30:47 -0400
Received: from complete.lackof.org ([198.49.126.79]:49420 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbZF3Tar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 15:30:47 -0400
Date: Tue, 30 Jun 2009 13:30:50 -0600
From: dann frazier <dannf@dannf.org>
To: Stephen Frost <sfrost@snowman.net>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Alex Chiang <achiang@hp.com>,
       linux-kernel@vger.kernel.org, David Altobelli <david.altobelli@hp.com>,
       nagananda.chumbalkar@hp.com
Subject: Re: ACPI issues on HP DL585 G2
Message-ID: <20090630193050.GA9496@lackof.org>
References: <20090628034038.GK20436@tamriel.snowman.net> <20090628172052.GA13957@ldl.fc.hp.com> <20090628223258.GP20436@tamriel.snowman.net> <20090630011541.GL22480@ldl.fc.hp.com> <20090630011709.GT20436@tamriel.snowman.net> <86802c440906291847p302d47eau1d1cbd07be59c61@mail.gmail.com> <20090630015140.GV20436@tamriel.snowman.net> <20090630015302.GN22480@ldl.fc.hp.com> <20090630020644.GW20436@tamriel.snowman.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090630020644.GW20436@tamriel.snowman.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 10:06:44PM -0400, Stephen Frost wrote:
> * dann frazier (dannf@dannf.org) wrote:
> > What about your other working DL585 boxes? Are they G2's, and are they
> > also using P600s?
> 
> The other DL585 G2 that I've got with the latest BIOS/etc, running under
> 2.6.29, has a P800 installed, and it's working fine.  Actually, the
> other DL585 G2's that we had problems running something newer than
> 2.6.22 on also had P600's..  It was quite a while ago that we tried to
> upgrade those (around 2.6.26), but I'm guessing if we tried now we'd hit
> the same issue.
> 
> Don't suppose you can grab a P600 from somewhere and try?

Got one, and I am able to reproduce a hang while initializing
cciss. I'll try narrowing down the issue.

-- 
dann frazier

