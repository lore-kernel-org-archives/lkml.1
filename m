Return-Path: <linux-kernel-owner+w=401wt.eu-S935417AbXEIBf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935417AbXEIBf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 21:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935304AbXEIBfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 21:35:36 -0400
Received: from ns2.lanforge.com ([66.165.47.211]:32773 "EHLO ns2.lanforge.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935294AbXEIBff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 21:35:35 -0400
X-Greylist: delayed 3641 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 May 2007 21:35:35 EDT
Message-ID: <4641172B.3010109@candelatech.com>
Date: Tue, 08 May 2007 17:34:51 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Writing to file-system at high speeds from a kernel module.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to write to disk from a kernel module at high
sustained speeds.

Do I have to somehow query the file-system caches to see how
much memory they are using, or perhaps flush the file after
a certain number of bytes to keep the system from using all
of it's RAM in file-system buffers?

[ Yes, I know this is an evil thing to attempt, and Greg did not
   show me how to do it! :) ]

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

