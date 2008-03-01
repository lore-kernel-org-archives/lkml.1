Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbYCAFPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbYCAFPR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 00:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYCAFPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 00:15:04 -0500
Received: from outbound-mail-19.bluehost.com ([69.89.20.234]:54551 "HELO
	outbound-mail-19.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751135AbYCAFPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 00:15:02 -0500
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Romano Giannetti <romanol@upcomillas.es>
Subject: Re: Intel 945GM: 2.6.25-rc3 report (with a possible regression)
Date: Fri, 29 Feb 2008 21:14:55 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Frans Pop <elendil@planet.nl>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org
References: <1204056556.7745.22.camel@localhost> <E1JULSV-0001qy-7N@faramir.fjphome.nl> <1204190794.16668.4.camel@pern>
In-Reply-To: <1204190794.16668.4.camel@pern>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802292114.55352.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 28, 2008 1:26 am Romano Giannetti wrote:
> On Wed, 2008-02-27 at 13:32 +0100, Frans Pop wrote:
> > This sounds like that could be a bug I filed recently and which was
> > solved in 2.2.1: http://bugs.freedesktop.org/show_bug.cgi?id=14481.
>
> Yes, it seems the same. I will try as soon as I came around to a way to
> do it.

Good to see we're fixing things for some people at least (re: Stephan's 
message).

> Could this account to the LCD/CRT switching problem to? This is the most
> critical to me, since I can't use the laptop to give presentations. I
> double checked if the key combination is managed in user space, but it
> seems that it did not send ACPI events nor keypresses, so I suspect that
> it is a kernel matter (or BIOS, maybe).

The 2.2.1 release may nor may not affect your LCD/CRT switching, but I know at 
least 2.6.25-rc3 has some ACPI key event reporting issues that may be fixed 
now (at least in the ACPI tree).

Jesse
