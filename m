Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbZKPNkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbZKPNkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 08:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbZKPNkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 08:40:43 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:33265 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbZKPNkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 08:40:42 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: -rc6: something (probably active usb bluetooth) blocks suspend
Date: Mon, 16 Nov 2009 14:43:20 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
       linux-bluetooth@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20091116112254.GB12315@elf.ucw.cz>
In-Reply-To: <20091116112254.GB12315@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911161443.20704.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 16. November 2009 12:22:54 schrieb Pavel Machek:
> Linux amd 2.6.32-rc6-00498-g05b553a-dirty #89 SMP Fri Nov 13 10:43:31
> CET 2009 i686 GNU/Linux
> 
> ...and yes, it is a regression. Hw is thinkpad x60.
> 
> Tried to suspend, machine came right back, used radio kill switch, and
> it suspended ok. Relevant messages seem to be:

I forgot to ask. Is this repeatable? The code is build on the assumption
that workqueues are frozen as the system calls suspend for system
sleep. If that assumption is wrong, a race can lead to this failure.
Is it wrong?

	Regards
		Oliver
