Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbZGSNew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbZGSNew (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 09:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbZGSNev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 09:34:51 -0400
Received: from solo.fdn.fr ([80.67.169.19]:42660 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219AbZGSNeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 09:34:50 -0400
Date: Sun, 19 Jul 2009 15:34:48 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [RFC] tty (or char) bus?
Message-ID: <20090719133448.GA5328@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Tilman Schmidt <tilman@imap.cc>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
	"alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
References: <4A5CA4CB.8070500@tis.icnet.pl> <20090717175428.GB4852@const.linuxsymposium.org> <4A631D5A.3030105@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A631D5A.3030105@imap.cc>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt, le Sun 19 Jul 2009 15:19:22 +0200, a écrit :
> The only inconvenience is how LDs are loaded and attached to a serial
> interface, via the TIOCSETD ioctl, because you need a userspace daemon
> which keeps the tty device open so that the LD stays attached to it.

Yes, that's a burden for me also, while I could just tell my module to
use ttyS0 through parameters for instance.

Samuel
