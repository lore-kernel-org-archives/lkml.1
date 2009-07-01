Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbZGAODx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbZGAODx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbZGAODo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:03:44 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:56818 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbZGAODo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:03:44 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] cdc-acm: work around some broken devices
Date: Wed, 1 Jul 2009 16:03:56 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.30-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Arseniy Lartsev <ars3n@yandex.ru>, Alan Stern <stern@rowland.harvard.edu>,
       USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0906301656440.5222-100000@iolanthe.rowland.org> <200907011627.31170.ars3n@yandex.ru> <20090701135649.GA27932@kroah.com>
In-Reply-To: <20090701135649.GA27932@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907011603.56762.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 1. Juli 2009 15:56:49 schrieb Greg KH:
> On Wed, Jul 01, 2009 at 04:27:26PM +0400, Arseniy Lartsev wrote:
> > On Wednesday 01 July 2009 15:37:48 Oliver Neukum wrote:
> > > Yes, exactly. Please add greg@kroah.com into CC, add a Signed-off-by
> > > line and resend.
> >
> > ok
> >
> > Signed-off-by: Arseniy Lartsev <ars3n at yandex dot ru>
>
> Real email address please, no "at" or "dot", it messes up our scripts.
>
> And what does this patch do?  I need some text for the changelog.

This patch introduces a work around for cdc-acm devices which are
low speed contrary to the specification, which requires bulk endpoints
which are banned in low speed and converted by usbcore to virtual
interrupt endpoints if they are used nevertheless.

	Regards
		Oliver

