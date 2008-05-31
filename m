Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbYEaVvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbYEaVvd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 17:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbYEaVvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 17:51:25 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:42981 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbYEaVvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 17:51:25 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: [Bug #10825] appletouch after wakeup
Date: Sat, 31 May 2008 23:25:30 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik> <200805312030.57213.oliver@neukum.org> <dd18b0c30805311253q687bdc50j41f6c4fd93c5695c@mail.gmail.com>
In-Reply-To: <dd18b0c30805311253q687bdc50j41f6c4fd93c5695c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805312325.31753.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 31. Mai 2008 21:53:16 schrieb Justin Mattock:
> On Sat, May 31, 2008 at 6:30 PM, Oliver Neukum <oliver@neukum.org> wrote:
> > Am Samstag, 31. Mai 2008 19:48:06 schrieb Rafael J. Wysocki:
> >> This message has been generated automatically as a part of a report
> >> of recent regressions.
> >>
> >> The following bug entry is on the current list of known regressions
> >> from 2.6.25.  Please verify if it still should be listed.
> >
> > AFAIK it is current and should be listed.
> >
> >        Regards
> >                Oliver
> >
> >
> 
> I agree, right now I upgraded to the latest git on thursday, and
> performed a suspend to see if it would appear, but nothing.
> I did notice the same error while doing a reboot, and noticed
> appletouch was motionless until I removed and inserted the module back
> in.
> regards;
> 

Can you please add your device to the quirk lis in drivers/usb/core/quirks.c
with USB_QUIRK_RESET_RESUME and retest?

	Regards
		Oliver

