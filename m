Return-Path: <linux-kernel-owner+w=401wt.eu-S1752054AbZGXHMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbZGXHMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 03:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbZGXHMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 03:12:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58935 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbZGXHMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 03:12:14 -0400
Date: Fri, 24 Jul 2009 09:12:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH V2 1/4] fix a problem that linux/async.h can not be
	included in another header file
Message-ID: <20090724071207.GA10760@elf.ucw.cz>
References: <1248404520.2670.109.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248404520.2670.109.camel@rzhang-dt>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-07-24 11:02:00, Zhang Rui wrote:
> 
> include/linux/async.h:16: error: redefinition of typedef ???async_cookie_t???
> include/linux/async.h:16: error: previous declaration of ???async_cookie_t??? was here
> include/linux/async.h:17: error: redefinition of typedef ???async_func_ptr???
> include/linux/async.h:17: error: previous declaration of ???async_func_ptr??? was here
> 
> fix a problem that include/linux/async.h can not be included in another header file
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>

Acked-by: Pavel Machek <pavel@ucw.cz>
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
