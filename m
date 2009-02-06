Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbZBFBmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbZBFBmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 20:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbZBFBm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 20:42:28 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:63028 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbZBFBm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 20:42:27 -0500
Message-Id: <200902060141.n161fBl6043702@www262.sakura.ne.jp>
Subject: Re: [TOMOYO #15 6/8] LSM adapter functions.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: adobriyan@gmail.com
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       haradats@nttdata.co.jp, takedakn@nttdata.co.jp
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 06 Feb 2009 10:41:11 +0900
References: <20090205081810.331987920@nttdata.co.jp> <20090205082232.562805442@nttdata.co.jp> <20090205171055.GA2809@x200.localdomain>
In-Reply-To: <20090205171055.GA2809@x200.localdomain>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 06022009 #1583542, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> > +	if (tomoyo_prepend(&end, &buflen, "/proc/sys"))
> 
> Hardcoded path?
> 
Yes.

The sysctl's table tree is accessible via sys/ directory of proc filesystem.
Since this function is called by sysctl(2), we don't have a mount point.
On the assumption that proc filesystem is mounted on /proc/ , TOMOYO pretends
as if corresponding sysctl table entry under sys/ directory of proc filesystem
is accessed.

Regards.
