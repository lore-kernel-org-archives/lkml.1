Return-Path: <linux-kernel-owner+w=401wt.eu-S1754916AbYHYIyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbYHYIyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 04:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbYHYIyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 04:54:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:49335 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515AbYHYIyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 04:54:35 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Pavel Machek <pavel@suse.cz>
Subject: Re: autosuspend for SCSI devices
Date: Mon, 25 Aug 2008 10:55:44 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org,
       teheo@novell.com, stefanr@s5r6.in-berlin.de, Martin.Leisner@xerox.com
References: <20080822105626.GA9475@elf.ucw.cz> <200808222252.52947.rjw@sisk.pl> <20080825081901.GA32128@elf.ucw.cz>
In-Reply-To: <20080825081901.GA32128@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808251055.45582.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 25 August 2008 10:19:01 schrieb Pavel Machek:
> From: Alan Stern <stern@rowland.harvard.edu>
> 
> Add support for autosuspend/autoresume of the SCSI devices. Lowlevel
> driver can use it to spin the disk down... and it is neccessary step
> for powering down the controllers.
> 
> Spinning down the disk is useful - saves ~0.5W here, and it is last
> major thing we can do to save power on some small machines like
> Kohjinsha subnotebooks.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>

Hi,

firstly, it doesn't consider error handling before suspending.
Secondly, it is simply not true that in SCSI suspending the disks
is always necessary before suspending the controller.

	Regards
		Oliver

