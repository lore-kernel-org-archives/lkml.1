Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbXFUOri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbXFUOri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 10:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbXFUOrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 10:47:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42149 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbXFUOra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 10:47:30 -0400
Subject: Re: Writing a driver for a legacy serial device
From: David Woodhouse <dwmw2@infradead.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Dmitry Torokhov <dtor@insightbb.com>, LKML <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@ucw.cz>
In-Reply-To: <20070621113358.1d65678d@hyperion.delvare>
References: <20070619190502.05d4e0c8@hyperion.delvare>
	 <d120d5000706191159w29ebd0dajbd6cb9ac78d4faa2@mail.gmail.com>
	 <20070620105648.6d18ad66@hyperion.delvare>
	 <200706202311.33326.dtor@insightbb.com>
	 <20070621113358.1d65678d@hyperion.delvare>
Content-Type: text/plain
Date: Thu, 21 Jun 2007 22:47:12 +0800
Message-Id: <1182437233.2782.36.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-21 at 11:33 +0200, Jean Delvare wrote:
> OK. This leads me to a question: is it OK for me to add support for my
> non-input device to inputattach, or is a separate, dedicated helper
> tool preferred? Both ways are fine with me, I don't know what the
> input subsystem maintainers expect.

You might do better to implement it as a line discipline instead. 
Or just do it in userspace. What exactly are you trying to do?

-- 
dwmw2

