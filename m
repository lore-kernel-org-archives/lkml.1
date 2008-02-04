Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbYBDNRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbYBDNRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:17:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbYBDNQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:16:55 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:20407 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbYBDNQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:16:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=DBoxobgYhw6aPlzzMTrbfK7P5X8a1YJnBMX5AaJlNd91Mibo6fUZzlDx84EUnci/04s/kQFuJne7OTgwI0TcH8/Ndli9RrJwZST5kzD0tCi23UvcrLb27upEG/Fm360uGzDfhI+cf3GwSqSaxCdOCs5JyiHAK4/afM6PH+a7hP0=
Message-ID: <47A71040.5000300@gmail.com>
Date: Mon, 04 Feb 2008 20:16:48 +0700
From: Igor M Podlesny <for.poige+linux@gmail.com>
Reply-To: for.poige+linux@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071205 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Both 2.6.24-mm1 and 2.6.24-git11 do NOT "see" any of mine LVM-2 disks
References: <43d009740802022335y21c3f93ep4e444bef71338045@mail.gmail.com> <20080202235103.20dd9768.akpm@linux-foundation.org>
In-Reply-To: <20080202235103.20dd9768.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   Hello, everybody! :-)

On 2008-02-03 14:51, Andrew Morton wrote:
> On Sun, 3 Feb 2008 14:35:23 +0700 Igor <for.poige+linux@gmail.com> wrote:
>> On 02/02/2008, Igor <for.poige+linux@gmail.com> wrote:
[...]
>>     And I've tried linux-2.6.24-rc8-mm1 — it fails even running MDs saying
>> that do_md_run() returning -22.
> 
> I'm pretty sure that got fixed, thanks.
> 
> I'm trying to get 2.6.24-mm1 out.  Maybe tomorrow - please test that, make
> sure that we fixed it.

   Yeah, you've fixed it now, MD's are running OK.

   Now I can say that both 2.6.24-mm1 and 2.6.24-git11 do NOT "see" any
of mine LVM-2 disks. pvscan, for e.g., finds nothing at all.

   Mine system's configuration is LVM-2 on MD (Software RAID); 2.6.24
handles it just fine.

   P. S. I'm not subscribed to linux-kernel@vger.kernel.org (yet), so
please keep my e-mail address intact :-) when replying.

-- 
End of message. Next message?
