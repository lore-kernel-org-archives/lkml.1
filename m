Return-Path: <linux-kernel-owner+w=401wt.eu-S1030400AbXCSRpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030400AbXCSRpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 13:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030395AbXCSRpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 13:45:47 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34491 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030400AbXCSRpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 13:45:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oliver Falk <oliver@linux-kernel.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: axp question 'bout uname voodoo
References: <45FE80FD.9090109@linux-kernel.at>
Date: Mon, 19 Mar 2007 11:44:44 -0600
In-Reply-To: <45FE80FD.9090109@linux-kernel.at> (Oliver Falk's message of
	"Mon, 19 Mar 2007 13:24:29 +0100")
Message-ID: <m1ejnlxh4j.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Falk <oliver@linux-kernel.at> writes:

> Hi!
>
> We have a discussion on alpha mailinglist at the moment, because of uname -mpi.
>
> AFAIK, uname -m should do some glibc call, which calls kernel, right?
>
> However, I have two machines:
>
> AS1000A:
> [root@tyskie ~]# uname -mpi && cat /proc/cpuinfo | grep model
> alpha alpha alpha
> cpu model               : EV56
>
> DS10:
> [root@gosa ~]# uname -mpi && cat /proc/cpuinfo |grep model
> alpha alpha alpha
> cpu model               : EV67
>
> Shouldn't uname rport alphaev67 and alphaev56? Maybe it's just a .config
> problem. Maybe the kernel needs to be compiled for the different sub-arches!?
>
> Any help would be great.

The kernel uname function at least does not have fields that
report processor or hardware platform.

Eric
