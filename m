Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbZEFJdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbZEFJdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 05:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577AbZEFJdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 05:33:10 -0400
Received: from smtp4.welho.com ([213.243.153.38]:41095 "EHLO smtp4.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbZEFJdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 05:33:09 -0400
Date: Wed, 6 May 2009 12:33:07 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1-gpio: add external pull-up enable callback
Message-ID: <20090506093307.GC17782@sci.fi>
Mail-Followup-To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org
References: <1241527413-22920-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1241527413-22920-1-git-send-email-daniel@caiaq.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 02:43:33PM +0200, Daniel Mack wrote:
> On embedded devices, sleep mode conditions can be tricky to handle,
> Especially when processors tend to pull-down the w1 bus during sleep.
> Bus slaves (such as the ds2760) may interpret this as a reason for
> power-down conditions and entirely switch off the device.
> 
> This patch adds a callback function pointer to let users switch on and
> off the external pull-up resistor. This lets the outside world know
> whether the processor is currently actively driving the bus or not.

Looks simple enough but I wonder if you could just do this from the
platform code. I suppose the downside would be that you would enable the
pullup even if w1-gpio is not loaded.

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
