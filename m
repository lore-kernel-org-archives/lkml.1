Return-Path: <linux-kernel-owner+w=401wt.eu-S1751493AbXBVDkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbXBVDkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 22:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXBVDkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 22:40:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60129 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbXBVDkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 22:40:16 -0500
Date: Thu, 22 Feb 2007 03:40:01 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Roman Zippel <zippel@linux-m68k.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] EXPORT_SYMBOL() time functions
Message-ID: <20070222034001.GB9027@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Rolf Eike Beer <eike-kernel@sf-tec.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	john stultz <johnstul@us.ibm.com>,
	Roman Zippel <zippel@linux-m68k.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>
References: <200702211412.23388.eike-kernel@sf-tec.de> <200702211413.38840.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702211413.38840.eike-kernel@sf-tec.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 02:13:38PM +0100, Rolf Eike Beer wrote:
> These functions were inlines before 8b9365d753d9870bb6451504c13570b81923228f.
> Now EXPORT_SYMBOL() them to allow them to be used in modules again.

Just because they happened to be inlined that doesn't mean modules should
be using them.  In fact no intree module uses them exactly because they're
not intended to be used by this kind of code.  Please show the code you
want to use this for so we can see what you're really trying to do.

