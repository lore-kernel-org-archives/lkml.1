Return-Path: <linux-kernel-owner+w=401wt.eu-S1755688AbYJXU01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbYJXU01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 16:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbYJXU0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 16:26:19 -0400
Received: from waste.org ([66.93.16.53]:53123 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbYJXU0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 16:26:18 -0400
Subject: Bloatwatch 2.6.28-rc1: i8042 DMI lookup tables
From: Matt Mackall <mpm@selenic.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Kosina <jkosina@suse.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain
Date: Fri, 24 Oct 2008 15:25:59 -0500
Message-Id: <1224879959.3248.32.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've added 12k of new initdata to allnoconfig builds for i8042 DMI
lookup tables:

http://www.selenic.com/bloatwatch/?cmd=compare;v1=2.6.27;v2=2.6.28-rc1;part=/built-in/drivers

It looks like each table entry is > 320 bytes as we reserve four 80-byte
slots in each for DMI match strings. 

-- 
Mathematics is the supreme nostalgia of our time.

