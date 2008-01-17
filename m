Return-Path: <linux-kernel-owner+w=401wt.eu-S1762626AbYAQWya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762626AbYAQWya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:54:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761346AbYAQWpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:45:03 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:21429 "EHLO
	outbound7-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757330AbYAQWo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:44:59 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
From: "Joachim Deguara" <joachim.deguara@amd.com>
Organization: AMD
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [x86] please setup git for http access
Date: Thu, 17 Jan 2008 14:43:56 -0800
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
References: <200801151556.58881.joachim.deguara@amd.com>
 <478D5D13.70904@zytor.com>
In-Reply-To: <478D5D13.70904@zytor.com>
MIME-Version: 1.0
Message-ID: <200801171443.56750.joachim.deguara@amd.com>
X-OriginalArrivalTime: 17 Jan 2008 22:42:00.0110 (UTC)
 FILETIME=[2C0DF4E0:01C8595A]
X-WSS-ID: 6B9106782IW8056581-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 January 2008, H. Peter Anvin wrote:
> Joachim Deguara wrote:
> > Hello,
> >   I am trying to access the x86 git tree behind a proxy and therefore
> > over the http address.  This works for Linus' tree but not for the x86
> > tree.  Please follow these guidelines to enable http access.
> >
> > http://www.kernel.org/pub/software/scm/git/docs/user-manual.html#exportin
> >g-via-http
>
> Set up now.
>
> 	-hpa

Thanks but unfortunately it still seams not to be working.  I cannot 
sucessfully:
 git-clone 
http://www.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

I can see the git repository over http but I am guessing something did not go 
right with 'git --bare update-server-info' as the .git/info directory does 
not have the refs like Linus' does which are needed for http (gleaming this 
from man git-update-server-info).  There have been updates to the git tree 
since you responded so it looks like that hook did not get activated.  (these 
are guesses from me and I don't really know git well so don't trust a word I 
say)

thanks
-Joachim


