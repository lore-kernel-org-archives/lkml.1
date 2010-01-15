Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab0AOMEt (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 07:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757284Ab0AOMEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 07:04:48 -0500
Received: from netz.smurf.noris.de ([213.95.21.43]:41719 "EHLO
	netz.smurf.noris.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238Ab0AOMEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 07:04:48 -0500
Subject: Re: [PATCH] ldisc switching on a HUPped pty hangs the caller
From: Matthias Urlichs <matthias@urlichs.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100115104834.4765b584@lxorguk.ukuu.org.uk>
References: <1263532072.22171.24.camel@kiste>
	 <20100115104834.4765b584@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: {M:U} IT Design
Date: Fri, 15 Jan 2010 13:04:25 +0100
Message-ID: <1263557065.3325.28.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Smurf-Spam-Score: -2.6 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 10:48 +0000, Alan Cox wrote:
> > (The comment, by the way, seems to be wrong. There was no race.) 
> 
> Really ?
> 
Yes -- I didn't mean to imply that there was no possibility of a race,
but that there need not be any race for creating a deadlock situation.
A call to vhangup() is sufficient.

I'll test your fix later today. Rebooting a production gateway in the
middle of the work day isn't a good idea. :-P

