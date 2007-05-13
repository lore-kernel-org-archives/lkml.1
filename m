Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbXEMSiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbXEMSiT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 14:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757616AbXEMSiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 14:38:12 -0400
Received: from NEUROSIS.MIT.EDU ([18.95.3.133]:58969 "EHLO neurosis.jim.sh"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757548AbXEMSiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 14:38:12 -0400
X-Greylist: delayed 1195 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 May 2007 14:38:12 EDT
Date: Sun, 13 May 2007 14:18:06 -0400
From: Jim Paris <jim@jtan.com>
To: "Robin H. Johnson" <robbat2@gentoo.org>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-ide@vger.kernel.org,
       Fred Moyer <fred@redhotpenguin.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.21.1] SATA freeze
Message-ID: <20070513181806.GA19538@jim.sh>
References: <fa.zU1kuoSgByTYCYqY+iCQ5rMJy34@ifi.uio.no> <46460C1B.6000609@shaw.ca> <20070513012045.GA15162@curie-int.orbis-terrarum.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070513012045.GA15162@curie-int.orbis-terrarum.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >  This appears to be a different problem. Something is issuing SMART-related 
> >  commands (smartd or smartctl perhaps) which the drive seems to be reacting 
> >  strangely to.
..
> Specifically, I could trigger it by running 'smartctl -d ata -S on
> /dev/sda' OR (s-S/o/).

This sounds like a known bug in smartmontools:

  http://marc.info/?l=smartmontools-support&m=117203137719518
  http://www.mail-archive.com/linux-ide@vger.kernel.org/msg03160.html

-jim
