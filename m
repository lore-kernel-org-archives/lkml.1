Return-Path: <linux-kernel-owner+w=401wt.eu-S1758667AbYB1BiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667AbYB1BiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 20:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbYB1BiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 20:38:00 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:63115 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbYB1Bh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 20:37:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pg+rTABZuoB6pAJYz8gEfhF/Fqqm42miEfIaFb8OZ+BW9olvdZlVZW9aJFE7yuZlqaJ3u+rH4YHgIo2zlMJNqh05/I/2Zv9IURE760sm4BSnWVPx0k8gBANAGxLb6XENwIRw4nM7YtGa1TZmxam12yaBCmKao/IrHWpkC/fVM0A=
Message-ID: <a8e1da0802271737w46a926cdj228b1fa9b3a11af3@mail.gmail.com>
Date: Thu, 28 Feb 2008 09:37:59 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Quel Qun" <kelk1@comcast.net>
Subject: Re: Kernel oops with bluetooth usb dongle
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Marcel Holtmann" <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>, "Jiri Kosina" <jkosina@suse.cz>,
       "Ingo Molnar" <mingo@elte.hu>, "David Miller" <davem@davemloft.net>
In-Reply-To: <a8e1da0802271703x42152aabn8f5862b16357c083@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <022620080003.1247.47C35750000085C8000004DF2207300793CE05040A05@comcast.net>
	 <a8e1da0802271703x42152aabn8f5862b16357c083@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add davem to cc-list

On Thu, Feb 28, 2008 at 9:03 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
>
> On Tue, Feb 26, 2008 at 8:03 AM, Quel Qun <kelk1@comcast.net> wrote:
>  >  -------------- Original message ----------------------
>  >  From: Thomas Gleixner <tglx@linutronix.de>
>  >
>  >
>  > > On Fri, 22 Feb 2008, David Woodhouse wrote:
>  >  >
>  >  > > On Fri, 2008-02-22 at 08:23 +0100, Thomas Gleixner wrote:
>  >  > > >
>  >  > > > +       del_timer(&conn->info_timer);
>  >  > > > +
>  >  > > >         hcon->l2cap_data = NULL;
>  >  > > >         kfree(conn);
>  >  > >
>  >  > > Shouldn't that be del_timer_sync() ?
>  >  >
>  >  > Hmm, probably yes.
>  >  >
>  >  Hi,
>  >
>  >  Great news: only adding adding del_timer_sync() to 2.6.25-rc3 does prevent the crash.
>  >
>  >  Bad news: I still cannot use the device.
>  >
>  >  hcitool inq, hcitool scan, hcitool name <btaddr> and hcitool info <btaddr>
>  >  commands work.
>  >
>  >  hcitool cc <btaddr>, sdptool <btaddr>, rfcomm connect command fail, most of them
>  >  with a 'Connection reset by peer' error.
>
>  Could you send the dmesg and hcidump content while connecting (eg.
>  rfcomm connect)?
>
>
>
>  >
>  >  # rpm -q bluez-utils
>  >  bluez-utils-3.27-1mdv2008.1
>  >
>  >  Thank you,
>  >  --
>  >  Eric
>  >
>
