Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbXLFXZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbXLFXZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 18:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbXLFXZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 18:25:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50238 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbXLFXZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 18:25:21 -0500
Subject: Re: [dm-devel] Re: 2.6.24-rc4-mm1
From: Kay Sievers <kay.sievers@vrfy.org>
To: Valdis.Kletnieks@vt.edu
Cc: device-mapper development <dm-devel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <2955.1196982750@turing-police.cc.vt.edu>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	 <3941.1196941764@turing-police.cc.vt.edu>
	 <20071206040420.6c89c675.akpm@linux-foundation.org>
	 <4374.1196968688@turing-police.cc.vt.edu>
	 <20071206193843.GA25125@kroah.com>
	 <3ae72650712061404w170fc434nb1172e048216e139@mail.gmail.com>
	 <2955.1196982750@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Fri, 07 Dec 2007 00:24:04 +0100
Message-Id: <1196983444.2829.38.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/MaitxogBssMZZUW6P/iGEHH5V5PdeAIFv61R
 Mj7tHENeX09nLuUFTB0em4/81PYp+wlQ97bgqPfji3pId5nIJQ
 I63wiJkY2IQolUwve8YAZNYYr6zJTZ9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-06 at 18:12 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 06 Dec 2007 23:04:12 +0100, Kay Sievers said:
> 
> > What's the value of SYSFS_DEPRECATED? Care to set it to yes, if it isn't,
> > and try again?
> 
> I *knew* there was a D'Oh! error in here. ;)
> 
> Bisection is fast closing in on gregkh-driver-block-device.patch, which broke
> my LVM almost the exact same way the *last* time it showed up in -mm ;)

Oh, it must not, if SYSFS_DEPRECATED=y is set. I hope we fixed all
issues. Please let us know if it does not work, then we will need to
look into it.

> > A fix for LVM to handle symlinks instead of directories is in the LVM
> > CVS tree, but there wasn't a release since August.
> 
> I seem to recall it was 'nash' rather than LVM that had the indigestion the
> last time around.

I think that a recent nash should work, even with SYSFS_DEPRECATED=n.
Anyway, nothing should change when SYSFS_DEPRECATED set, nash works fine
here, with that.

Kay

