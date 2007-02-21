Return-Path: <linux-kernel-owner+w=401wt.eu-S1161222AbXBUNcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161222AbXBUNcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 08:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161235AbXBUNcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 08:32:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41133 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161222AbXBUNcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 08:32:50 -0500
Subject: Re: [PATCH] EXPORT_SYMBOL() time functions
From: Arjan van de Ven <arjan@infradead.org>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Roman Zippel <zippel@linux-m68k.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <200702211412.23388.eike-kernel@sf-tec.de>
References: <200702211412.23388.eike-kernel@sf-tec.de>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 21 Feb 2007 14:32:16 +0100
Message-Id: <1172064736.3531.191.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 14:12 +0100, Rolf Eike Beer wrote:
> These functions were inlines before 8b9365d753d9870bb6451504c13570b81923228f.
> Now EXPORT_SYMBOL() them to allow them to be used in modules again.


please do not add random exports without users; exports eat up kernel
size and memory. At minimum specify which mainline modules use the
exports..


