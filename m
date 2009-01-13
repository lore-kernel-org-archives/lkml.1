Return-Path: <linux-kernel-owner+w=401wt.eu-S1753238AbZAMX1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbZAMX1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbZAMX1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:27:38 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:58631 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753367AbZAMX1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:27:37 -0500
Date: Tue, 13 Jan 2009 23:27:34 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: driver creating directories under a device entry
Message-ID: <20090113232734.GS12431@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a driver which uses sysfs_create_dir() to create a set of
directories under the device sysfs directory to bundle up attributes
that are added common for each sub-part of the device.

Firstly, is this considered a problem

Secondly, sysfs_create_dir() is not exported so the driver cannot
currently be built as a module. Would a patch to export sysfs_create_dir
be acceptable?

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
