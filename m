Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbYI3OI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbYI3OI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 10:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbYI3OIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 10:08:50 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:56952 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbYI3OIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 10:08:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XRJO5ior9O9nFYsVCQJHq7QpEYY1An6/dsZKvjFkkbstHcto/9k9pcS+9gDiviu6Ge
         z+aYFoeFwy6kYP7hLOYnclCN3vIzB7YFSlUuGIbI58SEuNveAO3U0CWRjmsHkVBVSEB9
         CgXB1pzYvNf0/L14OYqDoNM8bP18qlA6BVkPE=
Date: Tue, 30 Sep 2008 16:08:34 +0200
From: Karol Lewandowski <lmctlx@gmail.com>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Karol Lewandowski <lmctlx@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: BUG: Commit 1b7fc5aae8867046f8d3d45808309d5b7f2e036a makes special keys on my T21 unusable after resume
Message-ID: <20080930140834.GA2362@localdomain>
References: <20080929221628.GA3082@localdomain> <200809300025.52904.rjw@sisk.pl> <20080929234005.GA2616@localdomain> <48E1AF0F.8060701@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E1AF0F.8060701@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 08:46:07AM +0400, Alexey Starikovskiy wrote:
> Karol Lewandowski wrote:
> >On Tue, Sep 30, 2008 at 12:25:52AM +0200, Rafael J. Wysocki wrote:
> >
> >>Can you see if the patch at
> >>http://bugzilla.kernel.org/attachment.cgi?id=18044&action=view
> >>(against current -git) helps?
> this patch is not in -rc8, and might even be postponed to 2.6.28-rc1.
> >
> >It doesn't help (and -rc8 doesn't help either).
> could you please uncomment "#define DEBUG" in the beginning of 
> drivers/acpi/ec.c?
> please also open bug report in bugzilla.kernel.org against ACPI and
> attach dmesg from working and broken kernel with enabled DEBUG.
> Let me know the number of bug report.

It's http://bugzilla.kernel.org/show_bug.cgi?id=11674

Thanks.
