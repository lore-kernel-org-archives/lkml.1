Return-Path: <linux-kernel-owner+w=401wt.eu-S1030319AbXDKW2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030319AbXDKW2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030470AbXDKW2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:28:15 -0400
Received: from server2.meudns3.com ([74.52.31.50]:55270 "EHLO
	server2.meudns3.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030319AbXDKW2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:28:14 -0400
From: Pedro <linux_user@izecksohn.com>
To: linux-kernel@vger.kernel.org
Subject: Re: tmpfs and the OOM killer
Date: Wed, 11 Apr 2007 19:27:00 -0300
User-Agent: KMail/1.9.5
References: <200704110223.31291.linux_user@izecksohn.com> <20070411194820.GI943@1wt.eu>
In-Reply-To: <20070411194820.GI943@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704111927.00609.linux_user@izecksohn.com>
X-PopBeforeSMTPSenders: linux_user@izecksohn.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server2.meudns3.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - izecksohn.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 April 2007 16:48, Willy Tarreau wrote:
> On Wed, Apr 11, 2007 at 02:23:31AM -0300, Pedro wrote:
> >   After suffering some days from a not|mis configured tmpfs,
> >
> >   As the OOM killer is not Posix,
> >
> >   Better than to kill processes would be to resize tmpfs, to use tmpfs
> > empty space.
>
> Will not work, because tmpfs does not use any memory for unused space. If
> you don't believe me, simply create a large file on your tmpfs, then check
> free memory, then remove the file and check free memory again.
>
> So your problem is not caused by the empty space on tmpfs, but either by
> too much space used on tmpfs or by your application using too much memory.
>
...
>
> If you cannot control your application's memory usage, you'll have to
> finely tune the overcommit_ratio.
>
> Regards,
> Willy

  You are right.

  But now I have two questions:

  1) Why is tmpfs total space fixed if at the check moment does not exist 
sufficient memory?

  2) How should an application be written to not be killed by OOM?
