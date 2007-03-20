Return-Path: <linux-kernel-owner+w=401wt.eu-S1752016AbXCTWL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbXCTWL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 18:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbXCTWL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 18:11:57 -0400
Received: from saeurebad.de ([85.214.36.134]:33076 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbXCTWL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 18:11:56 -0400
Date: Tue, 20 Mar 2007 23:11:47 +0100
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: "reboot" swsusp mode leaves moon icon blinking
Message-ID: <20070320221147.GA16162@leiferikson>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	linux-kernel@vger.kernel.org
References: <20070320123245.GA19019@elf.ucw.cz> <20070320165058.GA15888@leiferikson> <20070320180121.GA2856@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070320180121.GA2856@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 20, 2007 at 07:01:21PM +0100, Pavel Machek wrote:
> > What does the "reboot" swsusp mean?
> 
> echo reboot > ...disk.

Thank you.

> > I am having this (or a similar problem):
> > 
> > 	echo shutdown > /sys/power/disk; echo disk > /sys/power/state
> 
> Yep, that's duplicate. Try patch below.

I applied it and the box is suspending/resuming properly again.

=Hannes
