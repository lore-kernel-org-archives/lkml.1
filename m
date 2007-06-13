Return-Path: <linux-kernel-owner+w=401wt.eu-S1758184AbXFMWZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184AbXFMWZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 18:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbXFMWZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 18:25:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:40170 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbXFMWZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 18:25:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=avkAzGFri1A/og6nrnKvghlNaCjNtSVsDcBLiH099X4m7pdpVHC6cWFV+5Qnv+DXeQh5fD3ZobVN9JZVj4C9rcYKuNISXowWZ2ztE1Gko3eOpfS86KP6nW+QWf+SUDgCuYFZoTb62aWo7Ua8EviHFXFBc8U4aiyV1BH2YtYn0o8=
Message-ID: <9d732d950706131525n667587e6t59e94c5cee951c6d@mail.gmail.com>
Date: Thu, 14 Jun 2007 07:25:21 +0900
From: "Toshiharu Harada" <haradats@gmail.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [RFC] TOMOYO Linux
Cc: "Stephen Smalley" <sds@tycho.nsa.gov>,
       "Toshiharu Harada" <haradats@nttdata.co.jp>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <467064B9.1080005@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466FA71C.1020309@nttdata.co.jp>
	 <1181743635.17547.350.camel@moss-spartans.epoch.ncsc.mil>
	 <9d732d950706130722g12a22604p223381a8e281a4a1@mail.gmail.com>
	 <46704D49.8010308@redhat.com>
	 <9d732d950706131435s636b852di98026aed1d9a6ac6@mail.gmail.com>
	 <467064B9.1080005@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/6/14, Rik van Riel <riel@redhat.com>:
> Toshiharu Harada wrote:
> > 2007/6/14, Rik van Riel <riel@redhat.com>:
> > SELinux has a well designed robust and flexible functions.
> > So it should be used for everywhere.  I understand it.
> > As you mentioned one can analyze the system (process)
> > behaviors from AVC logs. But the maintenance cost is not trivial.
> >
> > If logging with process context is the only purpose,
> > current TOMOYO Linux can do it with no hustle at all.
>
> Yes, but so does standard SELinux.
>
> You are making me curious: what does TOMOYO do that is
> not done by regular SELinux?
>
> Logging with process name, path name and contexts is
> already done.  I must have missed some other TOMOYO
> feature in your initial email...

I see SELinux can log with process name, path name and
contexts, but "contexts" must be defined beforehand.
TOMOYO Linux kernel does that with pathname, so no
label definitions needed.
You can confirm the process (domain) transitions any time
and access occurred are clarified per domain basis automatically.
Security context in TOMOYO Linux is represented and stored
as a call chain and very intuitive.

TOMOYO Linux has a mode called "learning"
in addition to "permissive" and "enforce". You can easily
get the TOMOYO Linux policy with learning mode that
SELinux does not have. In addition, access control mode of
TOMOYO Linux can be managed for every difference domain.

-- 
Toshiharu Harada
haradats@gmail.com
