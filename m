Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690AbZJBVZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbZJBVZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 17:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbZJBVZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 17:25:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36663 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbZJBVZB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 17:25:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bruno =?utf-8?q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Subject: Re: [Bug #13950] Oops when USB Serial disconnected while in use
Date: Fri, 2 Oct 2009 23:26:33 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.VqC.POTxKB@chimera> <20091002214550.6727df5c@neptune.home>
In-Reply-To: <20091002214550.6727df5c@neptune.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200910022326.33270.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 October 2009, Bruno Prémont wrote:
> On Thu, 01 October 2009 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.30 and 2.6.31.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.30 and 2.6.31.  Please verify if it still
> > should be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13950
> > Subject	: Oops when USB Serial disconnected while in
> > use Submitter	: Bruno Prémont <bonbons@linux-vserver.org>
> > Date		: 2009-08-08 17:47 (55 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124975432900466&w=4
> > Handled-By	: Alan Stern <stern@rowland.harvard.edu>
> 
> This has been adressed with following commits:
>   41bd34ddd7aa46dbc03b5bb33896e0fa8100fe7b
>   usb-serial: change referencing of port and serial structures
> 
>   f5b0953a89fa3407fb293cc54ead7d8feec489e4
>   usb-serial: put subroutines in logical order
> 
>   8bc2c1b2daf95029658868cb1427baea2da87139
>   usb-serial: change logic of serial lookups
> 
>   cc56cd0157753c04a987888a2f793803df661a40
>   usb-serial: acquire references when a new tty is installed
> 
>   7e29bb4b779f4f35385e6f21994758845bf14d23
>   usb-serial: fix termios initialization logic
> 
>   74556123e034c8337b69a3ebac2f3a5fc0a97032
>   usb-serial: rename subroutines
> 
>   ff8324df1187b7280e507c976777df76c73a1ef1
>   usb-serial: add missing tests and debug lines
> 
>   320348c8d5c9b591282633ddb8959b42f7fc7a1c
>   usb-serial: straighten out serial_open
> 
> They went into 2.6.32-rc1 and are probably queued for 2.6.31.2 stable.

Thanks a lot for the detailed info, bug closed.

Rafael
