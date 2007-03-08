Return-Path: <linux-kernel-owner+w=401wt.eu-S1752053AbXCHAzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbXCHAzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 19:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbXCHAzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 19:55:42 -0500
Received: from gw.goop.org ([64.81.55.164]:57354 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbXCHAzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 19:55:42 -0500
Message-ID: <45EF5F0C.5070102@goop.org>
Date: Wed, 07 Mar 2007 16:55:40 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: tim.c.chen@linux.intel.com
CC: zach@vmware.com, linux-kernel@vger.kernel.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: system call time increase when turning on CONFIG_PARAVIRT
References: <1172866274.4898.14.camel@localhost.localdomain>	 <45E89CFB.4090905@goop.org> <1172877111.8383.4.camel@localhost.localdomain>	  <45E8BE79.40200@goop.org> <1173312124.8383.35.camel@localhost.localdomain>
In-Reply-To: <1173312124.8383.35.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Chen wrote:
> It turned out that VDSO was turned off by CONFIG_PARAVIRT option,
> causing the system call to use inefficient int 0x80 which led to the
> increase system_call time I was seeing.  I noted that Ingo has caught
> this problem and proposed a patch to correct this issue in another mail
> thread.

Thanks for identifying this.  We'll be posting a more general fix for
COMPAT_VDSO soon which will address this.

    J
