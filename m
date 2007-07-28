Return-Path: <linux-kernel-owner+w=401wt.eu-S938052AbXG1Hjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938052AbXG1Hjp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 03:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759076AbXG1Hji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 03:39:38 -0400
Received: from main.gmane.org ([80.91.229.2]:36174 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758138AbXG1Hjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 03:39:37 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: Re: Problems with reading DVD using 2.6.21.5
Date: Sat, 28 Jul 2007 09:44:20 +0200
Message-ID: <f8err9$d27$1@sea.gmane.org>
References: <fa.wwGTjo0zKd+GP1ok2NxTU1KXblw@ifi.uio.no> <46AAA0BE.5030102@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: pd9e42cd1.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.5) Gecko/20070723 FirefoxSucks/9 SeaMonkey/1.1.3
In-Reply-To: <46AAA0BE.5030102@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> I don't think this is a bug, the drive was told to read a sector and 
> returned error SK=03, ASC=02, ASCQ=00 which is "NO SEEK COMPLETE", in 
> other words it couldn't find that sector. Could be that the disc is 
> marginally readable and only sometimes causes read errors.

The disc is OK. No scratches and no fingerprints on the data side. The 
"position" of this error also seems to be not static. One boot before 
the one, where I saved the "ls -l" output, the directory "kde" has been 
unreadable. I unmounted and remounted the disc and immediately after 
that, all directories have been readable, again.

I was able to read exactly this disc with exactly this drive to get the 
MD5sum of the ISO on the disc. The MD5sum was OK. Even the gpgverify, I 
did immediately after the MD5sum, was OK. No read errors or any other 
problems.

The major problem is, that this one drove me nuts while installing 
Slackware, as I always was unsure if this silly installer now installed 
anything correctly or if I had read errors, again.

Why is this error gone after unmount/mount? Why isn't the kernel able to 
"reread" (retry) a part of the DVD, without the need to remount the 
whole disc?

Thanks very much in advance

CU

Manuel

