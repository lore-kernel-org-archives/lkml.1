Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbYCMMHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbYCMMHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 08:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYCMMHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 08:07:35 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:32874 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbYCMMHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:07:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nDKL5cbNKH/oDfrNLrH0vTqjuU1ASYPyOqGDuoU3sUzw3NTY7rogqIofQ6zRoF/Q3QLuBzJivp3Zn0arfL0BEPZbcvLb3gSXJrPcifKYSp5KtvEEXJZiB5C0QcYBHyWetvO4+HrG1kvzYmZcQm+4Bre/VRyy4deUeCCDQX1gl8c=
Message-ID: <4f2ee0160803130507n1d07e07iedf8ab9bc5778455@mail.gmail.com>
Date: Thu, 13 Mar 2008 07:07:26 -0500
From: "Prakhar Krishna" <prakhar2@gmail.com>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: How to compile kernel so it automatically reboots upon a crash instead of generating stack trace and then hang.
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
In-Reply-To: <e2e108260803120340u6e42b1d1hd3fc51bb92f21830@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4f2ee0160803112152y21bb99a7t331fc9eff214e756@mail.gmail.com>
	 <Pine.LNX.4.64.0803120602580.18745@fbirervta.pbzchgretzou.qr>
	 <e2e108260803120340u6e42b1d1hd3fc51bb92f21830@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks everyone for the information.

can it be presumed that boot option panic=<x> would always reboot the machine
upon a crash/null pointer dereference if it is not stuck in a
deadlock? also, is there any
place in kernel where, if desired, the panic time can be hardcoded and compiled
for my specific test kernel.

intention is to look for a way to make a regular PC with linux OS
behave close to a
customized hardware appliance through software only mechanism. that
way it becomes
much easier to send just software to the users, which they can load on any
PC without requiring them to have additional hardware inserted into it.

please CC me on replies.

thanks
PK

On Wed, Mar 12, 2008 at 5:40 AM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
> On Wed, Mar 12, 2008 at 6:04 AM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> >
> >  On Mar 11 2008 23:52, Prakhar Krishna wrote:
> >  >
> >  >[I did search the mailing lists archives and the Web but did not find an answer,
> >  > apololgies if this is duplicate question]
> >  >
> >  >i need my linux box to automatically reboot if it ever runs into a
> >  >kernel panic/crash etc.
> >
> >  panic=<timeout> boot parameter, as per
> >  Documentation/kernel-parameters.txt.
>
> The best solution in this case is a hardware watchdog. Hardware
> watchdogs are present on some server motherboards, most embedded x86
> CPU boards and also in PowerPC CPU's. The Linux kernel supports some
> hardware watchdogs, see also Device Drivers/Watchdog Timer Support in
> the Linux kernel config.
>
> The nmi_watchdog=<timeout> parameter might be interesting too. See
> also Documentation/nmi_watchdog.txt.
>
> Bart.
>
