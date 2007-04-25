Return-Path: <linux-kernel-owner+w=401wt.eu-S1031067AbXDYPZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031067AbXDYPZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031038AbXDYPZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:25:01 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:40020 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031067AbXDYPY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:24:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IMS6EcgMNApUDaRMR8HZ/yMcoQuKPOAM+X5Jk9ntY4ushHj63c3J9m+y/HO++zFosRoQFdyxUJt1ir92kZp/jUDeYWzcX0oAR/MHVKcmhC3+pOO797i1zyVwI6AanwoQ48LOrQdCZdDJjp/5SozTIri44g4btBgNpYes7cqDFnM=
Subject: Re: [3/3] 2.6.21-rc7: known regressions (v2)
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Dave Jones <davej@redhat.com>
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       James Simmons <jsimmons@infradead.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Richard Purdie <rpurdie@rpsys.net>
In-Reply-To: <20070425143305.GB27215@redhat.com>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org>
	 <20070423214909.GD3468@stusta.de>
	 <20070425040605.6d6b4a82.akpm@linux-foundation.org>
	 <20070425113102.GU3468@stusta.de> <20070425130102.GA10141@redhat.com>
	 <1177509014.29878.12.camel@daplas> <1177509136.29878.14.camel@daplas>
	 <20070425143305.GB27215@redhat.com>
Content-Type: text/plain
Date: Wed, 25 Apr 2007 23:24:42 +0800
Message-Id: <1177514682.4856.24.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-25 at 10:33 -0400, Dave Jones wrote:
> On Wed, Apr 25, 2007 at 09:52:16PM +0800, Antonino A. Daplas wrote:
>  > > And have you tried the following settings:
>  > > FB_BACKLIGHT=y
>  > > ACPI_IBM=n
>  > > ACPI_VIDEO=n
> 

BTW, there was one report where resume from RAM resulted in a screen
full of garbage.  It seems that the option acpi_sleep= (or s2ram -a3)
did not work for him anymore.  But it worked with s2ram and other
options. So if you have s2ram, try:

s2ram -f -s -a3
s2ram -f -m -a3
s2ram -f -p -m
s2ram -f -p -s

Tony 


