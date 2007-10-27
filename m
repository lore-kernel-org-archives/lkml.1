Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbXJ0TcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbXJ0TcG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 15:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbXJ0Tby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 15:31:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58494 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbXJ0Tby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 15:31:54 -0400
Subject: Re: [PATCH] 2.6.24-rc1: ensure "present" sysfs attribute even if
	battery is absent
From: David Woodhouse <dwmw2@infradead.org>
To: cbou@mail.ru
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, davidz@redhat.com, rhughes@redhat.com
In-Reply-To: <20071027184249.GA2982@zarina>
References: <200710272054.31160.arvidjaar@mail.ru>
	 <20071027184249.GA2982@zarina>
Content-Type: text/plain
Date: Sat, 27 Oct 2007 15:32:04 -0400
Message-Id: <1193513524.2915.18.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-10-27 at 22:42 +0400, Anton Vorontsov wrote:
> Well, PROP_PRESENT wasn't my idea, currently it's used by pmu and
> olpc drivers becuase it's not trivial to register/unregister their
> batteries on physical insertion/removal. I have some plans to teach
> at least pmu batteries to not use PROP_PRESENT. I don't have any
> OLPC, thus I can't convert it.

Actually it's not hard to do that. It was done this way in response to a
request from the userspace side. IIRC.

-- 
dwmw2

