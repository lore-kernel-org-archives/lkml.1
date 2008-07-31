Return-Path: <linux-kernel-owner+w=401wt.eu-S1756932AbYGaNKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932AbYGaNKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 09:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYGaNJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 09:09:57 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:41607 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbYGaNJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 09:09:57 -0400
Date: Thu, 31 Jul 2008 09:09:27 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: 2.6.27-rc1 + selinux new options = no httpd
In-reply-to: <Xine.LNX.4.64.0807311440100.17254@us.intercode.com.au>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Stephen Smalley <sds@tycho.nsa.gov>
Message-id: <200807310909.27619.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200807302254.26036.gene.heskett@gmail.com>
 <Xine.LNX.4.64.0807311440100.17254@us.intercode.com.au>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 July 2008, James Morris wrote:
>On Wed, 30 Jul 2008, Gene Heskett wrote:
>> Greetings;
>>
>> I just had to reboot backwards to 2.6.26 as I don't seem to be able to
>> turn off enough selinux stuff to allow apache (httpd) to run, on
>> 2.6.27-rc1 it cannot get perms to access its log files so it exits.
>
>Which new options?

Make xconfig-->security options:

XFRM Networking security hooks

 and several others just below it.  Unforch, I can't copy/paste the screen.  
My next build will be with the above option turned off for grins & giggles.
However, I have about 16 bundles of shingles yet to sail up onto a roof & nail 
down in the cooler parts of the day till I'm done.  Taken last evening, I'm 
on the right.

<http://gene.homelinux.net:85/gene/Garage-pix/p7300002.jpg>

>What AVC messages are you seeing?

I posted the whole screen from setroubleshoot earlier.

>Which distro are you using and what is the policy package version?

F8, selinux-policy-targeted-3.0.8-109.fc8
selinux-policy-3.0.8-109.fc8
policycoreutils-gui-2.0.33-3.fc8
checkpolicy-2.0.4-1.fc8
policycoreutils-2.0.33-3.fc8
selinux-policy-devel-3.0.8-109.fc8

System has been relabeled twice now, no change, and the setroubleshoot command 
suggested doesn't fix it.

>> Is there a specific fix for this?
>
>This is the first I've heard of this.
>
Caught me out too. :)
>
>- James

Thanks James.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
"More software projects have gone awry for lack of calendar time than for all
 other causes combined."
-- Fred Brooks, Jr., _The Mythical Man Month_
