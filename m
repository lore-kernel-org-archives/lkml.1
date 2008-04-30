Return-Path: <linux-kernel-owner+w=401wt.eu-S933145AbYD3UdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145AbYD3UdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759502AbYD3Ucz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:32:55 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:34552 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764217AbYD3Ucy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:32:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=pOR0phSkriTrVcUI7bXESnFex8sEzSsYfRk35lsYeJUZ5R+R8GVpzrvbEvkAxAq0xGKJqFekYvb5NT3AdgFiBkOzTIWeAlNNx6tB/Cx63AgJYucDAXdSvrS754P1JrgmE6cwc7+9yZs3VqaYKpq07sbqm1nm83fu5C0Q1DGr9Gs=
Message-ID: <ed10ee420804301332n5fb72f3jb9bdea03aa313fad@mail.gmail.com>
Date: Wed, 30 Apr 2008 13:32:52 -0700
From: "SL Baur" <steve@xemacs.org>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: Additional kconfig targets (cloneconfig, nonint_oldconfig etc)
Cc: "Andres Salomon" <dilinger@queued.net>, "Sam Ravnborg" <sam@ravnborg.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Dave Jones" <davej@codemonkey.org.uk>,
       "Roland McGrath" <roland@redhat.com>
In-Reply-To: <20080430080134.60346a12.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080429183531.GB19652@uranus.ravnborg.org>
	 <20080429172402.14d7d40b@ephemeral>
	 <ed10ee420804300345r5d4566d2uff5c3f49f1c15107@mail.gmail.com>
	 <20080430080134.60346a12.randy.dunlap@oracle.com>
X-Google-Sender-Auth: 3a58bcbc901a3a31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/30/08, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Wed, 30 Apr 2008 03:45:57 -0700 SL Baur wrote:

>  > Is there any reasonable way to embed the configuration file name in the kernel
>  > image like BSD does it?  /proc/config.gz is a good way to retrieve way to
>  > retrieve configuration information on a running system, not so good for pushing
>  > kernels out to a network and keeping track of the config files on the build
>  > machine.
>
>
> I don't know how BSD does it, but CONFIG_IKCONFIG does embed the
>  config image in the kernel.  It can be extracted with
>  scripts/extract-ikconfig.

No, that's not what I meant.  Now that we have a means of specifying
a configuration file by name, it would be nice if the file name could,
for example, be appended to EXTRAVERSION.  That's all it would
take to duplicate the behavior I misdescribed.


Eg. `make K=HPxw4300.config ...' would have "-HPxw4300" appended
to EXTRAVERSION.  Maybe this doesn't make sense any more, but it
was once something I wanted very much.

-sb
