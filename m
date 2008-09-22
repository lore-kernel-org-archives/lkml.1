Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbYIVVQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbYIVVQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 17:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbYIVVQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 17:16:21 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:36530 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbYIVVQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 17:16:21 -0400
Message-ID: <48D809A3.8040207@oracle.com>
Date: Mon, 22 Sep 2008 14:09:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       James Morris <jmorris@redhat.com>, Andrew Morgan <morgan@kernel.org>,
       Andreas Gruenbacher <agruen@suse.de>, Andrew Morton <akpm@osdl.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 2/2] file capabilities: turn on by default
References: <20080922184835.GA2826@us.ibm.com> <20080922184901.GA3688@us.ibm.com> <20080922120347.60a9171a.randy.dunlap@oracle.com> <20080922195647.GA25682@us.ibm.com>
In-Reply-To: <20080922195647.GA25682@us.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting Randy Dunlap (randy.dunlap@oracle.com):
>> On Mon, 22 Sep 2008 13:49:01 -0500 Serge E. Hallyn wrote:
>>
>>> Now that file capabilities can be turned off at boot, go ahead
>>> and compile them into the kernel by default by making
>>> CONFIG_SECURITY_FILE_CAPABILITIES=y the default.
>> Hi,
>>
>> How much code does this add to everyone's kernel?
> 
> Here are the sizes I get with Linus' plain tree and patched
> with both of these patches:
> 
> master  with file capabilities: 6241626
> master  w/o  file capabilities: 6241595
> 
> patched with file capabilities: 6241782
> patched w/o  file capabilities: 6241595
> 
> So actually I don't like the added size.
> 
>>> Note that the boot flag no_file_caps must be specified to turn
>>> file capabilities off, as by default they are on.  So the
>>> default behavior is in fact changed.
>> If most people want this enable, using 'no_file_caps' makes
>> some sense.  OTOH, if most people don't want/use it, then
>> having a 'file_caps_on' option would make more sense.
>>
>> Do you have any (unbiased :) ideas about this?
> 
> I'll sit this one out I guess :)

BTW, I like Stephen's suggestion of using file_caps=0/1 instead
of no_file_caps.

-- 
~Randy
