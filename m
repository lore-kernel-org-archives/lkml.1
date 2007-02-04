Return-Path: <linux-kernel-owner+w=401wt.eu-S1752270AbXBDKsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbXBDKsS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 05:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbXBDKsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 05:48:18 -0500
Received: from delta.idt.cz ([81.0.223.58]:1775 "EHLO delta.idt.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbXBDKsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 05:48:17 -0500
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Feb 2007 05:48:17 EST
Date: Sun, 4 Feb 2007 12:02:56 +0100
From: Michal Hocko <mstsxfx@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: mm: how to check for kernel pages
Message-ID: <20070204110256.GA10477@curandero.marconia.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
is there any effective and fast way how to find out whether page
given by its page frame number is currenly used by (mapped by) kernel?

At the time of checking I can rely that such page:
	- is not buddy allocator page and also not on per CPU lists
	- is not compound page
	- is not reserved page
Because I can check that from struct page's flags.
I was thinking about using rmap code to find all ptes, but I don't know
whether it is not too complicated way.

Thanks for all hints.

Please add me to Cc, because I am not the list member.
Best regards.
-- 
Michal Hocko

