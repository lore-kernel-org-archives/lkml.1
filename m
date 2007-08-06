Return-Path: <linux-kernel-owner+w=401wt.eu-S934171AbXHFXp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934171AbXHFXp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 19:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933291AbXHFXpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 19:45:17 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44447 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933144AbXHFXpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 19:45:14 -0400
X-Sasl-enc: vLSNj/XyKvUaX4o2JXvDeAYAPSxQ4HNnBYTeuIzXJ5Sm 1186443912
Date: Mon, 6 Aug 2007 20:45:09 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tejun Heo <htejun@gmail.com>
Cc: Michael Sedkowski <sedmich@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Disk spin down issue on shut down/suspend to disk
Message-ID: <20070806234509.GC27640@khazad-dum.debian.net>
References: <838f88840708051428p3d65ff42w627af4bc38f57de3@mail.gmail.com> <1186411815.4355.7.camel@nx6310> <20070806150159.GC31615@khazad-dum.debian.net> <200708061732.03425.rjw@sisk.pl> <46B75459.9020204@gmail.com> <1186424492.4355.1.camel@nx6310> <46B76BBC.9010107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B76BBC.9010107@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2007, Tejun Heo wrote:
> Michael Sedkowski wrote:
> >> Hmmm... If the problem only shows up on nx6325, it might be that ACPI is
> >> pulling unnecessary stunt.  Please apply the attached patch and report
> >> when the disk spins down and up.
> > 
> > Disk spins down on "Pre-shutdown prepare" and then goes up and down on
> > "Power down".
> 
> Oh... crap, so acpi wants to sync cache on shutdown.  I wonder whether
> it spins down the disk correctly.  Does emergency unload count increase
> after each power down?  Also, please post the result of 'dmidecode'.

You know, this actually make a lot of sense, and one can't even complain
about firmware that pulls that off.  Any chances of changing things
so that we inspect/snoop all tasks sent to the device, and filter them
out, or react to them accordingly?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
