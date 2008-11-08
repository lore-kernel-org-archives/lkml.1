Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbYKHTby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbYKHTby (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 14:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbYKHTbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 14:31:47 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43077 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbYKHTbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 14:31:46 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4915E91D.8080707@s5r6.in-berlin.de>
Date: Sat, 08 Nov 2008 20:31:41 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.17) Gecko/20081027 SeaMonkey/1.1.12
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: only build the tree if we really want to
References: <20081108054511.GA28846@kroah.com> <1226123143-28859-1-git-send-email-greg@kroah.com> <4915B769.6090403@s5r6.in-berlin.de> <20081108183044.GA16504@suse.de>
In-Reply-To: <20081108183044.GA16504@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, Nov 08, 2008 at 04:59:37PM +0100, Stefan Richter wrote:
>>> -endif # STAGING
>>> +endif # !STAGING_EXCLUDE_BUILD
>> Which purpose is the STAGING kconfig variable serving after this?
> 
> Sitting there and looking pretty :)
> 
>> It controls the visibility of the menu, but switching it off won't
>> switch off the staging drivers if they were previously enabled, would
>> it?
> 
> Try it and look in wonder :)
> 
> If something affects the visibility of the menu for those config
> options, it controls if those options can be enabled or not.

Right.  But if you had STAGING on, STAGING_EXCLUDE_BUILD off, and for
example ET131X on, then ET131X will still be on if you switch STAGING
off and save the configuration.
-- 
Stefan Richter
-=====-==--- =-== -=---
http://arcgraph.de/sr/
