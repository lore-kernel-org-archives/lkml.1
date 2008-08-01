Return-Path: <linux-kernel-owner+w=401wt.eu-S1757463AbYHAS7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbYHAS7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbYHAS7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:59:08 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:41201 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbYHAS7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:59:06 -0400
Date: Fri, 01 Aug 2008 14:52:11 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: 2.6.27-rc1 + selinux new options = no httpd
In-reply-to: <1217526473.20373.250.camel@moss-spartans.epoch.ncsc.mil>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
Message-id: <200808011452.11401.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200807302254.26036.gene.heskett@gmail.com>
 <1217515455.2902.94.camel@localhost.localdomain>
 <1217526473.20373.250.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 July 2008, Stephen Smalley wrote:
>On Thu, 2008-07-31 at 10:44 -0400, Eric Paris wrote:
>> On Thu, 2008-07-31 at 09:09 -0400, Gene Heskett wrote:
>> > On Thursday 31 July 2008, James Morris wrote:
>> > >What AVC messages are you seeing?
>> >
>> > I posted the whole screen from setroubleshoot earlier.
>>
>> I'm sorry but I can't seem to find it in your original message...
>>
>> http://marc.info/?l=linux-kernel&m=121747333012971&w=2
>>
>> Do you have another pointer?  I can't think of anything that went into
>> 2.6.27 related to SELinux that should have in any way changed file
>> access checks but I'll poke through the changelog and see if something
>> stands out...
>
>I suspect it is the append bug introduced by the vfs changes, fixed by
>http://marc.info/?l=linux-kernel&m=121726661110266&w=2
>
>httpd would only be allowed append permission to its log file by policy.

This fixed it right up a few hours ago, Steven.  Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Keep the phase, baby.
