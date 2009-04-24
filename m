Return-Path: <linux-kernel-owner+w=401wt.eu-S1759061AbZDXMBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061AbZDXMBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 08:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbZDXL7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 07:59:22 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:53627 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755606AbZDXL7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 07:59:16 -0400
Message-ID: <49F1A991.4060607@rsk.demon.co.uk>
Date: Fri, 24 Apr 2009 12:59:13 +0100
From: Richard Kennedy <richard@rsk.demon.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alessio Igor Bogani <abogani@texware.it>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Suggestions request for speed-up kernel compilation
References: <63a49ef40904240257w45cc9c03n6e71ff4e4f69209b@mail.gmail.com>
In-Reply-To: <63a49ef40904240257w45cc9c03n6e71ff4e4f69209b@mail.gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alessio Igor Bogani wrote:
> Hi All,
> 
> Sorry for my bad English.
> 
> I'm a kernel newbie and I would be very happy to receive some tips
> about kernel compilation from experienced developers.
> 
> I have recently elaborated some trivial patches. For each one I have
> done a build test at minimum and I find myself spend a lot of time
> waiting my Core Duo to accomplish this task. Make is a very smart tool
> but after a git pull or a git fetch origin/git reset --hard origin it
> can't help as desired.
> 
> Unfortunately I don't have a clustered compilation farm under my control. :-)
> 
> Anyone can suggest me how mitigate that issue?
> 
> Tips, RTFM, links will be appreciated as long as referred to real used
> technique.
> 
> Thanks in advance and sorry for stupid question.
> 
> Ciao,
> Alessio

check you're using enough make jobs for your processor & memory.
On my AMDX2 I find 'make -j 8' is quickest for a full rebuild.
regards
Richard
