Return-Path: <linux-kernel-owner+w=401wt.eu-S1753251AbZALJXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbZALJXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 04:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbZALJXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 04:23:12 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:40416 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbZALJXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 04:23:12 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: "Maciej Rutecki" <maciej.rutecki@gmail.com>
Subject: Re: 2.6.29-rc1 does not resume on Lenove T61
Date: Mon, 12 Jan 2009 10:23:40 +0100
User-Agent: KMail/1.9.10
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Zdenek Kabelac" <zdenek.kabelac@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
References: <c4e36d110901111152o63c4cda0j88f4c89950bd2b90@mail.gmail.com> <200901120903.20371.rjw@sisk.pl> <8db1092f0901120115q510755d5oadd9ed11140a3423@mail.gmail.com>
In-Reply-To: <8db1092f0901120115q510755d5oadd9ed11140a3423@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901121023.42017.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Monday 12 January 2009 10:15:48 schrieb Maciej Rutecki:
> I try remowe usbhid, hid, ehci_hcd, uhci_hcd, psmouse (s2ram and
> s2disk doesn't work), but I had problem with unloading usbcore:
> ERROR: Module usbcore is in use

That's OK. Without controller drivers usbcore does nothing.
Your problem is not related to usb.

(Most likely it was busy because you had usbfs mounted)

	Regards
		Oliver

