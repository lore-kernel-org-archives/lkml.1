Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbYJEK7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbYJEK7R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 06:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYJEK7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 06:59:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35646 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbYJEK7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 06:59:03 -0400
Date: Sun, 5 Oct 2008 11:58:49 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dmitry.torokhov@gmail.com, IvDoorn@gmail.com, hmh@hmh.eng.br,
       sitsofe@yahoo.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rfkill-input doesn't work until 5 minutes after boot
Message-ID: <20081005105849.GA4087@srcf.ucam.org>
References: <20081004204342.GA29620@srcf.ucam.org> <20081005004334.GA31844@srcf.ucam.org> <20081004214341.f4052ce8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081004214341.f4052ce8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 04, 2008 at 09:43:41PM -0700, Andrew Morton wrote:

> Jiffies wraparound is 49.7 days at HZ=1000.

Damn those pesky 32-bit systems.

> If someone adds a new rfkill_foo there's a risk that they'll forget to
> make the corresponding change here.  A comment at the definition sites
> would help.

Sure.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
