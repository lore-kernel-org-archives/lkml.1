Return-Path: <linux-kernel-owner+w=401wt.eu-S932163AbXBAWpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163AbXBAWpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 17:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932783AbXBAWpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 17:45:55 -0500
Received: from services110.cs.uwaterloo.ca ([129.97.152.166]:54486 "EHLO
	services110.cs.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932163AbXBAWpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 17:45:54 -0500
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Feb 2007 17:45:54 EST
Subject: Re: [PATCH] mm: fix page_mkclean_one
From: Mark Groves <mjgroves@uwaterloo.ca>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Message-Id: <1170369622.3453.72.camel@garangu>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.4.5 (1.4.5-7) 
Date: Thu, 01 Feb 2007 17:40:22 -0500
Content-Transfer-Encoding: 7bit
X-Miltered: at demeter with ID 45C26BC4.000 by Joe's j-chkmail (http://j-chkmail.ensmp.fr)!
X-UUID: 04ec070b-d3f7-4c40-8913-99e8e786623a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I have been been seeing a problem when using sendfile repeatedly on an
SMP server, which I believe is related to the problem that was
discovered recently with marking dirty pages. The bug, as well as a test
script, is listed at http://bugzilla.kernel.org/show_bug.cgi?id=7650.
Currently, we're experiencing errors where part of a previous packet is
being sent out rather than the current packet.

I have applied the patch Linus posted to a 2.6.19 kernel but am still
getting the problem. So I am wondering if there are any other places in
the kernel which mark pages as dirty which might require a similar
patch?


Regards,

Mark Groves
Researcher
University of Waterloo
Waterloo, Ontario, Canada

