Return-Path: <linux-kernel-owner+w=401wt.eu-S965737AbXCVF0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965737AbXCVF0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 01:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965739AbXCVF0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 01:26:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55781 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965737AbXCVF0p (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 01:26:45 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
From: Keith Owens <kaos@ocs.com.au>
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, sam@ravnborg.org
Subject: Re: $CHECK can't be overridden 
In-reply-to: Your message of "Thu, 22 Mar 2007 01:15:25 EDT."
             <20070322051525.GD17159@redhat.com> 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 22 Mar 2007 16:26:39 +1100
Message-ID: <12464.1174541199@kao2.melbourne.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones (on Thu, 22 Mar 2007 01:15:25 -0400) wrote:
>make help implies that supplying $CHECK on the command line
>should override sparse as the checker used when building with C=1
>Yet, this doesn't seem to be the case.
>
>This would be useful for cases where for eg, sparse isn't in
>the $PATH, allowing an explicit path to the executable to be
>passed in automated build environments.

Works for me.

# make C=1 CHECK=foo
Using somedir/linux as source for kernel
GEN     someobj/Makefile
CHK     include/linux/version.h
CHK     include/linux/utsrelease.h
CHK     include/linux/compile.h
CHECK   somedir/linux/kdb/modules/kdb_bt2.c
/bin/sh: foo: command not found


