Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbZGBCKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbZGBCKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 22:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbZGBCJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 22:09:53 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:61814 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbZGBCJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 22:09:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vB0YX826xDiUjFU2tjN7+kAo+4fsDePfooX77XAcyPQBgmlE3l3++E3o4fEX/AMelV
         lrEBgDWwBup5FyMrV4esEUfHjDE3PdLIw7jrYBYzHzLCfMY7Z7tbin2NZ8nH9Ru6bbta
         CC/ymDOiLrl1j5TTpb1fv5FwWzrYaxJNAGBp4=
MIME-Version: 1.0
In-Reply-To: <1246499203.9660.52.camel@falcon>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
	 <1246459661.9660.40.camel@falcon>
	 <200907011821.26091.bzolnier@gmail.com>
	 <200907011829.16850.bzolnier@gmail.com>
	 <1246499203.9660.52.camel@falcon>
Date: Thu, 2 Jul 2009 10:09:53 +0800
Message-ID: <b6a2187b0907011909l41b513fen3252ce00f7e4c9c9@mail.gmail.com>
Subject: Re: [Bug #13663] suspend to ram regression (IDE related)
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: wuzhangjin@gmail.com
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Etienne Basset <etienne.basset@numericable.fr>,
       David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 9:46 AM, Wu Zhangjin<wuzhangjin@gmail.com> wrote:
> it this too old? should i merge another git repository?
> I have tried to apply it manually, but unfortunately, also not work. any
> other patch needed?

You need to be undo those two patches below ...

> On Mon, Jun 29, 2009 at 11:51 PM, Etienne Basset<etienne.basset@numericable.fr>
> To have STR/resume work with current git, I have to :
> 1) apply Bart's patch
> 2) revert this commit : a1317f714af7aed60ddc182d0122477cbe36ee9b

or try to pull from Linus's tree and try again. Latest is now ...

commit d960eea974f5e500c0dcb95a934239cc1f481cfd
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Mon Jun 29 14:54:11 2009 -0700

    kernel-doc: move ignoring kmemcheck



Jeff.
