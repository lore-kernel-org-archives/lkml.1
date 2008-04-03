Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbYDCNeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbYDCNeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 09:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbYDCNd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 09:33:56 -0400
Received: from flusers.ccur.com ([12.192.68.2]:48106 "EHLO flusers.ccur.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbYDCNd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:33:56 -0400
X-Greylist: delayed 1980 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Apr 2008 09:33:56 EDT
Date: Thu, 3 Apr 2008 09:00:53 -0400
From: Tom Horsley <tom.horsley@ccur.com>
To: linux-kernel@vger.kernel.org
Subject: module parameters versus kernel command line
Message-ID: <20080403090053.56f243df@tomh>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just curious: Is there any reason even dynamically loaded
modules shouldn't be able to find module parameters on
the kernel command line? I haven't actually investigated
the code involved (since I have no idea where it is :-),
but it sure seems like it would be convenient to have
a single place to put module parameters where they
would always be found regardless of the module's static
or dynamic build mode (especially when multi-booting
different kernels built different ways).
