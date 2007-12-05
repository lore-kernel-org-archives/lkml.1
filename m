Return-Path: <linux-kernel-owner+w=401wt.eu-S1752740AbXLEOKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbXLEOKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 09:10:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbXLEOKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 09:10:01 -0500
Received: from bizon.gios.gov.pl ([212.244.124.8]:43529 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbXLEOKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 09:10:00 -0500
Date: Wed, 5 Dec 2007 15:09:05 +0100 (CET)
From: Krzysztof Oledzki <olel@ans.pl>
X-X-Sender: olel@bizon.gios.gov.pl
To: bugme-daemon@bugzilla.kernel.org
cc: Thomas Osterried <osterried@jesse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 9182] Critical memory leak (dirty pages)
In-Reply-To: <20071205135655.1A832108010@picon.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0712051457290.25120@bizon.gios.gov.pl>
References: <20071205135655.1A832108010@picon.linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-2025954388-1196863745=:25120"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-2025954388-1196863745=:25120
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 5 Dec 2007, bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=3D9182
>
>
> olel@ans.pl changed:
>
>           What    |Removed                     |Added
> -------------------------------------------------------------------------=
---
>          Component|Other                       |Other
>      KernelVersion|2.6.22-stable/2.6.23-stable |2.6.20-stable/2.6.22-
>                   |                            |stable/2.6.23-stable
>            Product|IO/Storage                  |Memory Management
>         Regression|0                           |1
>            Summary|Strange system hangs        |Critical memory leak (dir=
ty
>                   |                            |pages)
>

After additional hint from Thomas Osterried I can confirm that the problem=
=20
I have been dealing with for half of a year comes from continuous dirty=20
pages increas:

http://bugzilla.kernel.org/attachment.cgi?id=3D13864&action=3Dview (in 1 KB=
=20
units)

So, after two days of uptime I have ~140MB of dirty pages and that=20
explains why my system crashes every 2-3 weeks.

Best regards,


 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-2025954388-1196863745=:25120--
