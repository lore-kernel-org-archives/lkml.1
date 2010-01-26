Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308Ab0AZOXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab0AZOXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 09:23:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217Ab0AZOXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 09:23:05 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:38562 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284Ab0AZOXE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 09:23:04 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Fabio Bas - Officine Informatiche" 
	<fabio.bas@officineinformatiche.net>
Subject: Re: PROBLEM: freeze on ppp connection (using an usb "key" modem)
Date: Tue, 26 Jan 2010 15:23:21 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
References: <4B5ED90E.6060304@officineinformatiche.net> <201001261354.58287.oliver@neukum.org> <4B5EF86D.6070109@officineinformatiche.net>
In-Reply-To: <4B5EF86D.6070109@officineinformatiche.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001261523.21656.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 26. Januar 2010 15:13:01 schrieb Fabio Bas - Officine Informatiche:
> On 26/01/2010 13:54, Oliver Neukum wrote:
> > Am Dienstag, 26. Januar 2010 13:53:08 schrieb Rafael J. Wysocki:
> >> On Tuesday 26 January 2010, Fabio Bas - Officine Informatiche wrote:
> >> ...
> >>> The last working kernel i'm aware of is kernel 2.6.30, the first showing
> >>> the problem 2.6.32.2
> >>
> >> Can you test 2.6.31.x please?
> I'll download, compile and test it asap

Yes, that's the best step now.

> > 
> > Is there a bugzilla for this?
> 
> I've just created it and attached all of my logs
> http://bugzilla.kernel.org/show_bug.cgi?id=15146
> 
> > Sysrq-t?
> 
> Here's my new crash log; sysrq-t output refers to the time after the
> connection was estabilished but before the freeze. I've tried to
> alt+sysrq+t dìseveral times when the box was freezed, but i had no reply
> from the kernel.

It is too early. Your kernel log suggests generic ppp, which is odd.
If the bug still happens with the newest stable kernel, it would be
a good idea to compile a kernel with lock verification enabled.

	Regards
		Oliver
