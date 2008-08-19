Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbYHSHtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbYHSHtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 03:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbYHSHti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 03:49:38 -0400
Received: from ns2.suse.de ([195.135.220.15]:39133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbYHSHti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 03:49:38 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Power management for SCSI
Date: Tue, 19 Aug 2008 09:50:38 +0200
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@suse.cz>, Alan Stern <stern@rowland.harvard.edu>,
       James.Bottomley@hansenpartnership.com,
       "Linux-pm mailing list" <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, teheo@novell.com
References: <20080813095055.GA475@elf.ucw.cz> <Pine.LNX.4.44L0.0808131026320.2455-100000@iolanthe.rowland.org> <20080819073839.GA8726@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20080819073839.GA8726@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808190950.40790.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 19 August 2008 09:38:39 schrieb Pavel Machek:
 
> Would it make sense to split the patches into "autosuspend for SCSI
> devices" and "autosuspend for SCSI controllers" for easier
> review/merge? I guess I'll start with the devices, they seem easier...

Runtime PM will have to leave devices alone while error handling is active.
Unfortunately error handling is done at controller level. So I am afraid
this would be very difficult.

	Regards
		Oliver
