Return-Path: <linux-kernel-owner+w=401wt.eu-S1758458AbZEFJe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbZEFJe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 05:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZEFJeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 05:34:50 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:52986 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbZEFJeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 05:34:50 -0400
Date: Wed, 6 May 2009 11:34:45 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1-gpio: add external pull-up enable callback
Message-ID: <20090506093445.GA31875@buzzloop.caiaq.de>
References: <1241527413-22920-1-git-send-email-daniel@caiaq.de> <20090506093307.GC17782@sci.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090506093307.GC17782@sci.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 12:33:07PM +0300, Ville Syrjälä wrote:
> On Tue, May 05, 2009 at 02:43:33PM +0200, Daniel Mack wrote:
> > On embedded devices, sleep mode conditions can be tricky to handle,
> > Especially when processors tend to pull-down the w1 bus during sleep.
> > Bus slaves (such as the ds2760) may interpret this as a reason for
> > power-down conditions and entirely switch off the device.
> > 
> > This patch adds a callback function pointer to let users switch on and
> > off the external pull-up resistor. This lets the outside world know
> > whether the processor is currently actively driving the bus or not.
> 
> Looks simple enough but I wonder if you could just do this from the
> platform code. I suppose the downside would be that you would enable the
> pullup even if w1-gpio is not loaded.

That's right. Hence I put it where I believe it belongs to.

Thanks,
Daniel
