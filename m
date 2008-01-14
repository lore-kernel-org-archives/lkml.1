Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbYANWN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbYANWN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbYANWNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:13:18 -0500
Received: from wx-out-0506.google.com ([66.249.82.239]:25033 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYANWNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:13:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SgaclFLUhZB55hPlUHQf5rS3oTqDi8jTTaiE8jMeCwbxL/WKcZeL5k8Wko88KE+LPTkaCILX7AtfdkleaQR15pPBwPVspwGy0nY7kdfJVnvkqfUiKv/eBZpm0azLCj8Scr9sBic/EgDmeFnMEOI51aI1EeGaM4R82eYaRi12Uxk=
Message-ID: <4d8e3fd30801141413x15d81576lc56eebfa726f1dbb@mail.gmail.com>
Date: Mon, 14 Jan 2008 23:13:14 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: checkpatch: add filename before the summary line
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080114173032.GE19327@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080113233405.5fcdaff5@paolo-desktop>
	 <20080114173032.GE19327@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 14, 2008 6:30 PM, Andy Whitcroft <apw@shadowen.org> wrote:
> On Sun, Jan 13, 2008 at 11:34:05PM +0100, Paolo Ciarrocchi wrote:
> > With the patch applied the output of checkpatch.pl is as follow:
> > ./arch/arm/mach-footbridge/ebsa285-pci.c
> > total: 1 errors, 0 warnings, 48 lines checked
> >
> > Adding the file name allowed me to collects stats running:
> >       find . -name *.c |xargs ./scripts/checkpatch.pl --file |grep -B 1 total
> > but I though it might me useful for other purposes to add the file name
> > after the list of errors and warnings and before the summary,
> > when the list is long I find handy to print out the filename as a reminder.
>
> Hmmm, that being unconfitional would probabally break a raft of other
> users.  Also would it be more useful to put it on the front of the
> summary line?  So that if you have a bunch of files to check then you
> get something more like:
>
> foo: total: 1 errors, ...
> bar: total: 0 errors, ...

I have a patch that adds an option (default to false) and with that I have
the following output:

./arch/sparc/kernel/apc.c --> total: 18 errors, 3 warnings, 186 lines checked
./arch/sparc/kernel/apc.c --> total: 18 errors, 3 warnings, 186 lines checked

Will send to the list in a few minutes.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
