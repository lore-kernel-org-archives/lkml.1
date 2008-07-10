Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbYGJIZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbYGJIZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 04:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbYGJIYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 04:24:47 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:59736 "EHLO
	orion.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbYGJIYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 04:24:46 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jul 2008 04:24:46 EDT
Message-ID: <4875C615.90102@cateee.net>
Date: Thu, 10 Jul 2008 10:19:33 +0200
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: bug in 2.6.26-rc9: sleeping function called from invalid context
 at kernel/rwsem:21
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

yesterday at shutdown I had a crash. Unfortunately it seems
that there was one (or more) oops missing. The bug appeared
at unmounting partition at shutdown, so there are no logs
of the previous messages.

A photo of the screen is in:
http://cateee.net/files/oops/20080709010.jpg

The oopes was in the git tree of two days ago.  I've not
seen this crash on last kernel, but OTOH I don't know if
the bug was reproducible.

ciao
	cate


PS: unfortunately I had not time for further tests and
better report, but I hope the trace is enough for such
bugs.
