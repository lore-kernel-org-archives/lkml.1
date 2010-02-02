Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab0BBSUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 13:20:39 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:59337 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab0BBSUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 13:20:36 -0500
Message-ID: <4B686CEC.4000107@s5r6.in-berlin.de>
Date: Tue, 02 Feb 2010 19:20:28 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: James Bottomley <James.Bottomley@suse.de>, joe@perches.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 05/10] drivers/scsi/arcmsr: Fix continuation line formats
References: <cover.1264967493.git.joe@perches.com> <1a318fa326c6ab2584b9d318bd1538e7f7debbdf.1264967499.git.joe@perches.com> <1a318fa326c6ab2584b9d318bd1538e7f7debbdf.1264967499.git.joe@perches.com> <1265044616.6910.15.camel@mulgrave.site> <201002011902.33015.elendil@planet.nl>
In-Reply-To: <201002011902.33015.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> James Bottomley wrote:
>>> -                     printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \
>>> -                     timeout, retry count down = %d \n", acb->host->host_no, retry_count);
>> 
>> So I might personally dislike this style
> 
> The problem here is not style, but that the whitespace of the indentation
> on the second line becomes part of the output!
> That makes the code defective and is why Joe posted the patch series.

Joe could have pointed this out in the changelog.
s/are not good/incorporate unintended whitespace/

[James wrote:]
>> Why?  It's perfectly valid ansi C.

Its syntax is valid but not its semantics.

>> Consider this change veto'd unless you can get an explicit ack from the
>> current maintainer for changing their style.

How about the maintainer takes the fix patch and adjusts style to his
liking?  (That's what I would do because I like fix submissions.)
-- 
Stefan Richter
-=====-==-=- --=- ---=-
http://arcgraph.de/sr/
