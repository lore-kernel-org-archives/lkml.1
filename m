Return-Path: <linux-kernel-owner+w=401wt.eu-S1757708AbZAMM4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708AbZAMM4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 07:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbZAMM4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 07:56:46 -0500
Received: from sorrow.cyrius.com ([65.19.161.204]:40239 "EHLO
	sorrow.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796AbZAMM4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 07:56:46 -0500
X-Greylist: delayed 1538 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2009 07:56:46 EST
Date: Tue, 13 Jan 2009 13:30:56 +0100
From: Martin Michlmayr <tbm@cyrius.com>
To: Frans Pop <elendil@planet.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.28] Kernel panic after closing lid on HP 2510p
Message-ID: <20090113123056.GA2464@deprecation.cyrius.com>
References: <200901121356.46236.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901121356.46236.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frans Pop <elendil@planet.nl> [2009-01-12 13:56]:
> I got the following series of errors while closing the lid of my notebook.
> The end result was a frozen system that needed a hard power off.
...
> System is HP 2510p notebook running 2.6.28 (x86_64, Debian amd64/lenny)
> with a few additional patches on top. 

This came up on lkml and elsewhere before.  It's probably a BIOS bug.
You can work around it with:

  echo 7 > /proc/acpi/video/C09A/DOS

-- 
Martin Michlmayr
http://www.cyrius.com/
