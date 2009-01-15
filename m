Return-Path: <linux-kernel-owner+w=401wt.eu-S1759695AbZAOIlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695AbZAOIlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 03:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbZAOIlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 03:41:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:8729 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbZAOIlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 03:41:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m/CCjPfruvpGGcQ0yJvMeL97M+LzA0BBvvN98m4k4xJ5TcqJy6jP3cPDYNjoKJUJRk
         16w5TfFiq3XvpYHdOhq0t/+4hdP807cWdJJ5BjVqNyMNMIYE+5a0cCHPtE4hxOHllPJy
         QGnUsVB/g9m/C6KcL09c0gcuSe/f/dpL3UxyM=
Date: Thu, 15 Jan 2009 11:41:10 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "harvey.harrison@gmail.com" <harvey.harrison@gmail.com>,
       "sam@ravnborg.org" <sam@ravnborg.org>,
       "jaswinderrajput@gmail.com" <jaswinderrajput@gmail.com>
Subject: Re: [patch 3/5] x86: headers cleanup - ptrace-abi.h
Message-ID: <20090115084110.GB9032@localhost>
References: <20090114203745.285473388@gmail.com>> <496e4e23.0c07560a.5e4e.529c@mx.google.com> <496E6585.8050505@zytor.com> <928CFBE8E7CB0040959E56B4EA41A77E0CD9CD33@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E0CD9CD33@irsmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Metzger, Markus T - Thu, Jan 15, 2009 at 08:06:31AM +0000]
| >-----Original Message-----
| >From: H. Peter Anvin [mailto:hpa@zytor.com]
| >Sent: Wednesday, January 14, 2009 11:22 PM
| >To: Cyrill Gorcunov; Metzger, Markus T
| >Cc: mingo@elte.hu; linux-kernel@vger.kernel.org; harvey.harrison@gmail.com; sam@ravnborg.org;
| >jaswinderrajput@gmail.com; Cyrill Gorcunov
| >Subject: Re: [patch 3/5] x86: headers cleanup - ptrace-abi.h
| >
| >Okay, this one really looks wrong to me.
| >
| >Markus, could you confirm if this was ever intended to be exported to
| >userspace?  I suspect The Right Thing is simply to remove the #ifdef
| >CONFIG_X86_TRACE_BTS here...
| 
| This is intended for userspace.
| I added the #ifdef so the entire feature could be turned off.
| This might not be necessary for declarations and macros, though.
| 
| Do you want me to remove the #ifdef CONFIG around the declarations in ptrace headers?
| 
| regards,
| markus.

Hi Markus,

since it's supposed to be visible by userspace then we
should just remove this CONFIG_X86_PTRACE_BTS so if userspace
app has a reference to ptrace_bts_config but kernel in turn has
this feature turned off -- the uerspace app shouldn't fail
while being compiling.

| >
| >	-hpa
| >
| >
...

		- Cyrill -
