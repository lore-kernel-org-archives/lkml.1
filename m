Return-Path: <linux-kernel-owner+w=401wt.eu-S965019AbZGQRye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965019AbZGQRye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 13:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964987AbZGQRyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 13:54:33 -0400
Received: from toccata.ens-lyon.fr ([140.77.166.68]:51032 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964966AbZGQRyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 13:54:33 -0400
Date: Fri, 17 Jul 2009 13:54:28 -0400
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [RFC] tty (or char) bus?
Message-ID: <20090717175428.GB4852@const.linuxsymposium.org>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
	"alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
References: <4A5CA4CB.8070500@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A5CA4CB.8070500@tis.icnet.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Janusz Krzysztofik, le Tue 14 Jul 2009 17:31:23 +0200, a écrit :
> In my attempt to add support for contols to a voice modem codec sound 
> device driver, I found that in order to talk to the modem, it would be 
> convenient if I can get access to a tty device from inside the kernel in 
> a way similiar to that available form userspace.

I agree.

> AFAICS, even if tty lowlevel write() could be used unmodified, a
> convenient way of reading characters from a tty is missing and should
> be implemented in a line discipline. Please correct me if I am wrong.

Have you seen the receive_buf line discipline hook?  Indeed it's not a
read() operation as from userland, but at least you can get the data
from the tty that way.

> OTOH, I found that some kind of abstraction layer for acccessing devices 
> over a tty could be convenient. Instead of allocating a new line 
> discipline for each specific device, sometimes found on a specific board 
> only, why not just create a new bus type?

I'd tend to agree with you, as I also have a use case for that: braille
& speech synthesis devices.  However for now I haven't found a really
convincing argument why line disciplines aren't enough.

Samuel
