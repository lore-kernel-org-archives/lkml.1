Return-Path: <linux-kernel-owner+w=401wt.eu-S1756623AbXLSD2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbXLSD2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 22:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbXLSD2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 22:28:30 -0500
Received: from mail8.dotsterhost.com ([66.11.233.1]:42742 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755024AbXLSD2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 22:28:25 -0500
Message-ID: <47688FEA.9070905@crispincowan.com>
Date: Tue, 18 Dec 2007 19:28:42 -0800
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.9 (X11/20071114)
MIME-Version: 1.0
To: Stephen Smalley <sds@tycho.nsa.gov>
CC: David Howells <dhowells@redhat.com>, Karl MacMillan <kmacmill@redhat.com>,
       viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM
 settings for task actions [try #2]
References: <1197401823.28006.74.camel@moss-spartans.epoch.ncsc.mil>	 <1197322068.18120.176.camel@moss-spartans.epoch.ncsc.mil>	 <1197307397.18120.72.camel@moss-spartans.epoch.ncsc.mil>	 <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil>	 <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>	 <20071205193859.24617.36392.stgit@warthog.procyon.org.uk>	 <25037.1197306473@redhat.com> <25572.1197320887@redhat.com>	 <25965.1197329769@redhat.com>   <9789.1197405725@redhat.com> <1197408847.28006.184.camel@moss-spartans.epoch.ncsc.mil>
In-Reply-To: <1197408847.28006.184.camel@moss-spartans.epoch.ncsc.mil>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley wrote:
>> It is if I have to maintain a special pieces of code for each possible LSM.
>> One piece for SELinux, one piece for AppArmour, one piece for Smack, one piece
>> for Casey's security system.  That sounds like a pain.
>>     
> All your code has to do is invoke a function provided by libselinux.  If
> at some later time a liblsm is introduced that provides a common
> front-end to a libselinux, libsmack, ..., then you can use that.  But it
> doesn't exist today.   But it all just becomes a simple function call
> regardless.
>   
libapparmor exists. It only had one API, and now it has 2, but just 2
versions on the same concept (change_hat and change_profile).

This is the API for change_hat http://man-wiki.net/index.php/2:change_hat

What does the corresponding API in SELinux look like?

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
CEO, Mercenary Linux		   http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work

