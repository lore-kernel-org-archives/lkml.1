Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbYHZLAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbYHZLAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 07:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbYHZLAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 07:00:36 -0400
Received: from mx1.suse.de ([195.135.220.2]:49318 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbYHZLAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 07:00:36 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Pavel Machek <pavel@suse.cz>
Subject: Re: autosuspend for SCSI devices
Date: Tue, 26 Aug 2008 13:01:43 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org,
       teheo@novell.com, stefanr@s5r6.in-berlin.de, Martin.Leisner@xerox.com
References: <20080822105626.GA9475@elf.ucw.cz> <200808251055.45582.oneukum@suse.de> <20080826094355.GA30062@elf.ucw.cz>
In-Reply-To: <20080826094355.GA30062@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808261301.45167.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 26 August 2008 11:43:55 schrieb Pavel Machek:
> > firstly, it doesn't consider error handling before suspending.
> 
> What problems do you see with error handling? This patch does not
> touch the error handling, and I do not think it needs to touch it.

You'd make scsi driver writers' life easier if you made sure no autosuspends
happen while they recover from errors. After all, you have no idea which
commands will get through while the bus is in disarray.

	Regards
		Oliver

