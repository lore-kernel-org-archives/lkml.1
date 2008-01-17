Return-Path: <linux-kernel-owner+w=401wt.eu-S1759500AbYAQWSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500AbYAQWSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757662AbYAQWSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:18:06 -0500
Received: from nz-out-0506.google.com ([64.233.162.231]:27575 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339AbYAQWSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:18:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Qzq+QDFy6v8nGbyVinm1QA4tZe/TIfXuMzh0FnSQ8l2A66JZFSFoSvioEnt5TUoB8CoKSH+exx1trVsjr6FIFidTYvC063euLKyWsdM9853+B4qQCIiUJCLPw9MzqNuALxpIIneFxnVuqdAW/GsM4vJrf2FkfF9wJV6/OYYvmkw=
Date: Thu, 17 Jan 2008 16:29:59 -0500
From: Joseph Fannin <jfannin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: 2.6.24-rc8-mm1 - mkubootimg wants <zlib.h>
Message-ID: <20080117212959.GA26254@nineveh.local>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>,
	Sam Ravnborg <sam@ravnborg.org>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117023514.9df393cf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 02:35:14AM -0800, Andrew Morton wrote:
>
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc8/2.6.24-rc8-mm1/

>  git-kbuild.patch

The "kbuild: rework arch specific Makefiles to use mkubootimg"
changeset in Kbuild git introduces a kernel build dependency on the
system zlib.h headers; scripts/mkubootimg/crc32.c wants it.

The build errors out if those headers aren't installed.  Was this
intentional?

--
Joseph Fannin
jfannin@gmail.com

