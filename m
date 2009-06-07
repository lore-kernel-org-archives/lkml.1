Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbZFGWCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbZFGWCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 18:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbZFGWCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 18:02:12 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:47750 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbZFGWCL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 18:02:11 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Run-time PM idea (was: Re: [linux-pm] [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Mon, 8 Jun 2009 00:02:54 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Magnus Damm <magnus.damm@gmail.com>
References: <Pine.LNX.4.44L0.0906071651060.25203-100000@netrider.rowland.org> <200906072347.00580.rjw@sisk.pl>
In-Reply-To: <200906072347.00580.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906080002.54914.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 7. Juni 2009 23:46:59 schrieb Rafael J. Wysocki:
> + * Use @work to get the device object the resume has been scheduled for,
> + * check if the device is really suspended and run the ->autoresume()
> callback + * from the device's bus type driver.  Update the run-time PM
> flags in the + * device object to reflect the current status of the device.
> + */
> +static void pm_autoresume(struct work_struct *work)
> +{

Why do you pass it a struct work pointer?

	Regards
		Oliver

