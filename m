Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbYJDWu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbYJDWu3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 18:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbYJDWuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 18:50:21 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50636 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbYJDWuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 18:50:20 -0400
Date: Sat, 4 Oct 2008 23:50:11 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dmitry.torokhov@gmail.com, IvDoorn@gmail.com, hmh@hmh.eng.br,
       sitsofe@yahoo.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rfkill-input doesn't work until 5 minutes after boot
Message-ID: <20081004225011.GA30886@srcf.ucam.org>
References: <20081004204342.GA29620@srcf.ucam.org> <20081004153929.846a0bde.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081004153929.846a0bde.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 04, 2008 at 03:39:29PM -0700, Andrew Morton wrote:

> That'll only work as intended if CONFIG_RFKILL_INPUT=y?  If the module
> is loaded 10 minutes after boot, the timestamp is still wrong.  It might
> happily happen to work, but will still fail after 2^31 jiffies (or something
> like that).

Mm. True. I'll fix it up to do it at load time.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
