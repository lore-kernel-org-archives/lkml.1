Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbYBYXca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbYBYXca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 18:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbYBYXcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 18:32:22 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:45923 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbYBYXcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:32:21 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [git patches] net driver updates
Date: Tue, 26 Feb 2008 01:34:01 +0200
User-Agent: KMail/1.9.7
References: <OF5F5F5698.07AB615F-ON652573F6.00142D8A-652573F6.00147DC9@in.ibm.com> <8A71B368A89016469F72CD08050AD334026D652F@maui.asicdesigners.com> <47C34838.3040502@garzik.org>
In-Reply-To: <47C34838.3040502@garzik.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802260134.02075.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 February 2008 12:59:04 am you wrote:
> Divy Le Ray wrote:
> >> From: "Divy Le Ray" <divy@chelsio.com>
> >> Date: Wed, 20 Feb 2008 21:57:08 -0800
> >>
> >>> The driver is cxgb3 here, it uses LLTX.
> >>
> >> That's extremely unfortunate, hopefully you can update it to
> >> use a model like tg3 and others use.  LLTX is a lost cause
> >> for hardware device drivers, and in fact we'd like to remove
> >> it tree wide eventually.

Just for info: loopback.c uses it too :-)

> >
> > It sounds like I messed up.
> > cxgb3 does not use LLTX - The Chelsio driver does, thus should be
> > converted.
>
> So, it sounds like Krishna's patch is ok, because the race does not
> exist anymore in this driver?
>
> 	Jeff
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


