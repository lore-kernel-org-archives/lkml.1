Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbYBYHeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbYBYHeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 02:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbYBYHeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 02:34:07 -0500
Received: from el-out-1112.google.com ([209.85.162.181]:58942 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbYBYHeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 02:34:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kqTk9zzWQte+oCKJDTp18/LpupQm+lUpzSK9diTGeHgJ+QQtgJLENauXBO7YDe5jdZDI76MPfv43DXOtz9zMXsUHiEXFZbTOj5DiSNw6UPQSbsLugAEKEiCVo8SIOKLQIY0SZpJKrUiWPoxuDsV5eEug/FhijvQQCUc6SAXHXug=
Message-ID: <a8e1da0802242334v23a60cb4q1953b5caf5eb9947@mail.gmail.com>
Date: Mon, 25 Feb 2008 15:34:02 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: linux-bluetooth@vger.kernel.org
Subject: Re: [Bluez-devel] forcing SCO connection patch
Cc: louis@mizi.com, "Marcel Holtmann" <marcel@holtmann.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "David Miller" <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
In-Reply-To: <a8e1da0802242330l765b8b1ava62b857baf8a5568@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47666E1F.2000902@mizi.com>
	 <a8e1da0802242330l765b8b1ava62b857baf8a5568@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 3:30 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> Quote mail from louis@mizi.com :
>
>  2007/12/17 Louis JANG <louis@mizi.com>:
>
>
> > Hello everybody,
>  >
>  >  I attached two patches. the first one(bluez-kernel-forcesco.patch) is to
>  >  force using HCI_OP_ADD_SCO instead of HCI_OP_SETUP_SYNC_CONN, and the
>  >  second one is to handle SCO connection complete event but its request
>  >  was ESCO.
>  >
>  >  1.
>  >  I'm developing bluetooth functions in my linux phone project, and I'm
>  >  using bluez for my job. I've tested lots of headsets, and found that I
>  >  coudn't connect SCO channel with HCI_OP_SETUP_SYNC_CONN in some old
>  >  headsets. I could connect SCO channel with HCI_OP_ADD_SCO in this case.
>  >  however, there is no api to force using SCO instead of ESCO in bluez. so
>  >  I added SCO_FORCESCO to handle this old headsets
>  >
>  >  2.
>  >  When I tried to connect SCO channel with
>  >  HCI_OP_SETUP_SYNC_CONN(LINK_TYPE_ESCO), some bluetooth headsets responds
>  >  with LINK_TYPE_SCO because it did not support ESCO. But bluez couldn't
>  >  handle this situation, and patch_hci_event.c is for this.
>  >
>  >
>  >  BRs
>  >  Louis JANG
>  >
>  >
>
>  Reply from bmidgley@gmail.com:
>
>  On Mon, Feb 25, 2008 at 2:43 PM, Brad Midgley <bmidgley@gmail.com> wrote:
>  > Louis
>
> >
>  >
>  >  >  When I tried to connect SCO channel with
>  >  >  HCI_OP_SETUP_SYNC_CONN(LINK_TYPE_ESCO), some bluetooth headsets responds
>  >  >  with LINK_TYPE_SCO because it did not support ESCO. But bluez couldn't
>  >  >  handle this situation, and patch_hci_event.c is for this.
>  >
>
> >  Marcel looked at this patch and came back with the comments below. Can
>  >  you revisit it? I think some other people are seeing the same issues.
>  >  The patch won't go upstream until Marcel likes it.
>  >
>  >  the patch you sent me is fully broken. First of all the coding style
>  >  is wrong. Does nobody have learned this by now? I always look for that
>  >  first before even reading the patch. Second the case where an
>  >  ESCO_LINK returns NULL is broken and will fall over and crash.
>  >
>  >  --
>  >  Brad
>  >
>
>
>  I ever asked marcel about the coding style. please see following thread:
>  http://lkml.org/lkml/2008/1/22/91
>
>  I think the style problem marcel said is
>  1. using kernel codeing style
>  2. marcel's style
>  container_of or get_user_data calls at the top of the variable declaration
>  using the empty lines to seperate code blocks
>
>  Please rework your patch and resend if you fixed them.
>
>  BTW, please use the new bluetooth mailing list for kerne issue.
>  linux-bluetooth@vger.kernel.org
>
>  (Thanks for andrew and davem)

On bugzilla, bug 9871 are same problem as yours.

add davem and netdev in cc-list

>
>  Regards
>  dave
>
>  Regards
>  dave
>
