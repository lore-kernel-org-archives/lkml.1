Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbYCPMlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbYCPMlp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 08:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbYCPMlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 08:41:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35664 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbYCPMle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 08:41:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: Suspend to RAM reboots on resume with S3
Date: Sun, 16 Mar 2008 13:41:05 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <frhpc6$99f$1@ger.gmane.org>
In-Reply-To: <frhpc6$99f$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803161341.06364.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 16 of March 2008, Sitsofe Wheeler wrote:
> Hello,

Hi,

> I have a desktop on which suspend to RAM has always fails to resume when 
> the BIOS is set to use S3 - when attempting to resume the video BIOS 
> posts itself, warms the monitor up, powersaves it, posts itself again and 
> goes to the regular BIOS post indicating a reboot. Hibernation started 
> working many kernels ago. Windows 98 seems able to do suspend to RAM on 
> S3 and Linux will suspend to RAM if S1 is set in the BIOS. The latest 
> test was done with 2.6.25-rc5 (git tree pulled this morning) and the 
> result is the same in kernels going back to 2.6.17 . Using pm_trace gives 
> a magic number that doesn't match anything:
> [    2.466686] Using IPI Shortcut mode
> [    2.467205]   Magic number: 0:691:51
> [    2.468707] Freeing unused kernel memory: 320k freed
> 
> (Originally filed on 
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/86099 ).

I've created the Bugzilla entry at
http://bugzilla.kernel.org/show_bug.cgi?id=10260
for this problem.  Please add yourself to the CC list in there.

Thanks,
Rafael
