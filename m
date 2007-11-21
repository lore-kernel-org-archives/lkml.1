Return-Path: <linux-kernel-owner+w=401wt.eu-S1758836AbXKUUOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836AbXKUUOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 15:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbXKUUO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 15:14:28 -0500
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:51423
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756612AbXKUUO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 15:14:27 -0500
From: Michael Buesch <mb@bu3sch.de>
To: benh@kernel.crashing.org
Subject: Re: radeonfb i2c regression post-2.6.18.
Date: Wed, 21 Nov 2007 21:13:19 +0100
User-Agent: KMail/1.9.6
Cc: Roger Leigh <rleigh@whinlatter.ukfsn.org>,
       Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       Dennis Munsie <dmunsie@cecropia.com>
References: <1195427766.7022.18.camel@pasglop> <87oddoaqa6.fsf@hardknott.home> <1195675089.6970.96.camel@pasglop>
In-Reply-To: <1195675089.6970.96.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711212113.19450.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 November 2007 20:58:09 Benjamin Herrenschmidt wrote:
> 
> > > Can you try the patch from Jean that I pasted below and let us know if
> > > it helps ? It looks like the releasing of the i2c lines may have been
> > > done backward.
> > 
> > This patch fixes the problem.  The monitor stays powered on during the
> > switch to the framebuffer.
> 
> Excellent ! That saves me having to test myself :-)
> 
> As far as I'm concerned, that's an Ack for the patch.

I'll test tomorrow if that also fixes my problem.
You'll hear from me.

-- 
Greetings Michael.
