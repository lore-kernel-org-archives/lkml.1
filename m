Return-Path: <linux-kernel-owner+w=401wt.eu-S1760402AbXIZRDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760402AbXIZRDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 13:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbXIZRDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 13:03:36 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:47907 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbXIZRDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 13:03:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GI0QdYS1sBicXwPf6B39o45PwoFsvR/SbuqWV5yEmSeXm9jcjKh979ivZhRBSpSJ1eFW16Dlc6Pp/27g4HZnW4oUrMxXK4RQps57+XbjljPIN4nUNUY/Aob7l0XXSTyL2sxwBxUeI/HiNmyEvvUHwBRuj7gv7xJxVcdO2XFB0MI=
Message-ID: <a36005b50709261003j923835fu621882c54706d476@mail.gmail.com>
Date: Wed, 26 Sep 2007 10:03:33 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "John Z. Bohach" <jzb2@aexorsyst.com>
Subject: Re: __kernel_vsyscall () hangs in SIGCHLD handler
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200709260757.20478.jzb2@aexorsyst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709260757.20478.jzb2@aexorsyst.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/26/07, John Z. Bohach <jzb2@aexorsyst.com> wrote:
> Is there some reason that syslog() sleeps in __kernel_vsyscall() when
> invoked from a signal handler?

Only very few functions are allowed to be called from signal handlers.
 This is clearly spelled out in the POSIX spec.  Section XSH 2.4.3
lists the allowed functions.  syslog of course is not on it.
