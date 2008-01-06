Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbYAFDOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbYAFDOT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 22:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbYAFDNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 22:13:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57757 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbYAFDNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 22:13:47 -0500
Date: Sat, 5 Jan 2008 19:07:13 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, heiko.carstens@de.ibm.com, olof@lixom.net,
       mingo@elte.hu, mpm@selenic.com
Subject: [patch 0/5] enhance WARN_ON series
Message-ID: <20080105190713.73745ec6@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3rd try for this patch series; now with a split up patch for __WARN_ON

This series has the goal of extending the usefulness of the WARN_ON() information,
at least on architectures that use the generic WARN_ON() infrastructure. (Those who
do their own thing either already have the extra information, or could consider
switching to the generic code). In order to do that, WARN_ON() first needs to 
be uninlined since there's like 1200 callsites and adding code to each of those
isn't pretty.

As part of this, I had to split the __WARN_ON patch in -mm into 2 pieces, one to 
introduce __WARN_ON, and a separate one to do the ifdef cleanup. 

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
