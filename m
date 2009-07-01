Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbZGARkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbZGARkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 13:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbZGARkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 13:40:43 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60410 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158AbZGARkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 13:40:43 -0400
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: X server hung, kernel said "task blocked for >120 secs" (2.6.30)
In-Reply-To: Your message of "Mon, 22 Jun 2009 15:31:57 PDT."
             <20090622153157.ac408188.akpm@linux-foundation.org>
X-Mailer: MH-E 8.1; nmh 1.3; GNU Emacs 22.3.1
Date: Wed, 01 Jul 2009 12:48:09 -0400
From: Sanjoy Mahajan <sanjoy@MIT.EDU>
Message-Id: <E1MM2yf-0002dX-Lg@approx.mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Have been away for 10 days and just saw the message]

> I assume this is a regression?  Since 2.6.29?

I never saw it before using 2.6.30 and haven't been able to reproduce
it even running 2.6.30.  

So it could be a regression.  Or it could be a recurring problem (I had
a few X lockups with earlier kernels) now exposed by a blocked-task
timer (the "INFO: task events/0:9 blocked for more than 120 seconds"
message) -- if that notification code is new in 2.6.30?

-Sanjoy

`Until lions have their historians, tales of the hunt shall always
 glorify the hunters.'  --African Proverb
