Return-Path: <linux-kernel-owner+w=401wt.eu-S1762747AbXFTJPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762747AbXFTJPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 05:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762609AbXFTJOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 05:14:55 -0400
Received: from www19.your-server.de ([213.133.104.19]:2775 "EHLO
	www19.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762535AbXFTJOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 05:14:53 -0400
From: Uli Luckas <u.luckas@road.de>
Organization: Road GmbH
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH -mm] PM: Prevent frozen user mode helpers from failing the freezing of tasks
Date: Wed, 20 Jun 2007 11:14:35 +0200
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200706182329.58917.rjw@sisk.pl>
In-Reply-To: <200706182329.58917.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706201114.35876.u.luckas@road.de>
X-Authenticated-Sender: webmaster@road.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 18. June 2007, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> At present, if a user mode helper is running while
> usermodehelper_pm_callback() is executed, the helper may be frozen and the
> completion in
> call_usermodehelper_exec() won't be completed until user space processes
> are thawed.  As a result, the freezing of kernel threads may fail, which is
> not desirable.
>
> Prevent this from happening by introducing a counter of running user mode
> helpers and allowing usermodehelper_pm_callback() to succeed for
> action = PM_HIBERNATION_PREPARE or action = PM_SUSPEND_PREPARE only if
> there are no helpers running.  [Namely, usermodehelper_pm_callback() waits
> for at most RUNNING_HELPERS_TIMEOUT for the number of running helpers to
> become zero and fails if that doesn't happen.]
>
> Special thanks to Uli Luckas <u.luckas@road.de> for reviewing the previous
> versions of this patch and for very useful comments.
>

Acked-by: Uli Luckas <u.luckas@road.de>

Regards,
Uli

-- 

------- ROAD ...the handyPC Company - - -  ) ) )

Uli Luckas
Software Development

ROAD GmbH
Bennigsenstr. 14 | 12159 Berlin | Germany
fon: +49 (30) 230069 - 64 | fax: +49 (30) 230069 - 69
url: www.road.de

Amtsgericht Charlottenburg: HRB 96688 B
Managing directors: Hans-Peter Constien, Hubertus von Streit
