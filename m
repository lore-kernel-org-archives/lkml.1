Return-Path: <linux-kernel-owner+w=401wt.eu-S933761AbXGaScV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933761AbXGaScV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763375AbXGaScK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:32:10 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:32286 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416AbXGaScJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:32:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=A/YB038y3doBUIyLO1cIAns27utSzKqNK2QE/89Dqu8uOll7w+ub5Ht0f3LSQaZFSB4r/cXTjMg1qc10KGkK8MxRxQW1Lbi6DuvQksP1e/8vNIWDkY7wIPo5TS6OsWgk5Tn+F/aPu1wjrRO03wEO9jxPZ2j0AyQ+P1/ATAI886I=
Date: Tue, 31 Jul 2007 20:31:49 +0200
From: Diego Calleja <diegocg@gmail.com>
To: trelane@digitasaru.net
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: inotify and /proc/<pid>
Message-Id: <20070731203149.eb8babb1.diegocg@gmail.com>
In-Reply-To: <20070731032521.GD6812@digitasaru.net>
References: <20070731021615.GB6812@digitasaru.net>
	<20070731031720.GF21089@ftp.linux.org.uk>
	<20070731032521.GD6812@digitasaru.net>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Mon, 30 Jul 2007 22:25:21 -0500, Joseph Pingenot <trelane@digitasaru.net> escribió:

> More background, please?
> 
> What's the way to check for a process exiting without spinning?


I don't know if it's useful for you, but CONFIG_CONNECTOR and CONFIG_PROC_EVENTS
will report process creation/exit/fork/etc through a netlink interface.
