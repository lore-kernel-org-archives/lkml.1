Return-Path: <linux-kernel-owner+w=401wt.eu-S935298AbXLQCgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935298AbXLQCgA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 21:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764661AbXLQCfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 21:35:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51339 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758352AbXLQCfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 21:35:50 -0500
Subject: Re: [PATCH 1/5] power: RFC: introduce a new power API
From: David Woodhouse <dwmw2@infradead.org>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru, akpm@linux-foundation.org
In-Reply-To: <20071216212443.4a1fff3d@ephemeral>
References: <20071216212443.4a1fff3d@ephemeral>
Content-Type: text/plain
Date: Sun, 16 Dec 2007 21:36:24 -0500
Message-Id: <1197858984.3798.201.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-12-16 at 21:24 -0500, Andres Salomon wrote:
> This API has the power_supply drivers device their own device_attribute
> list; I find this to be a lot more flexible and cleaner.  For example,
> rather than having a function with a huge switch statement (as olpc_battery
> currently has), we have separate callback functions.  We're not limited
> to drivers only being able to pass 'int' and 'char*'s in sysfs, we're
> not forced to keep a global string around in memory (as is again the
> case for olpc_battery's serial number code), we don't have ordering
> restrictions w/ the return value being interpreted based upon where it's
> located in the array... etc.  The other API seems to encourage driver
> authors to get their custom sysfs knobs into the list of sysfs knobs, and
> this one doesn't.
> 
> If there is interest in this API, I'll convert the rest of the power_supply
> drivers over to it and resubmit patches.

Looks sane enough to me. If Anton has no objections, I'll merge it.

> Ignore the psy->num_properties indentation below; that was done so patch #4
> wasn't stupidly large.

Interesting... but I suppose it makes sense.

-- 
dwmw2

