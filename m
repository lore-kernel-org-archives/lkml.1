Return-Path: <linux-kernel-owner+w=401wt.eu-S1757870AbXLHJgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbXLHJgy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 04:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756078AbXLHJgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 04:36:45 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44254 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756185AbXLHJgo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 04:36:44 -0500
Date: Sat, 8 Dec 2007 01:36:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-Id: <20071208013631.3147986a.akpm@linux-foundation.org>
In-Reply-To: <200712080340.49546.rjw@sisk.pl>
References: <200712080340.49546.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007 03:40:49 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message contains a list of some regressions from 2.6.23 which have been
> reported since 2.6.24-rc1 was released and for which there are no fixes in the
> mainline that I know of.  If any of them have been fixed already, please let me
> know.
> 
> If you know of any other unresolved regressions from 2.6.23, please let me know
> either and I'll add them to the list.
> 
> 
> Subject		: PATA scan: ACPI Exception AE_AML_PACKAGE_LIMIT... is beyond end of object
> Submitter	: Hans de Bruin <bruinjm@xs4all.nl>
> References	: http://bugzilla.kernel.org/show_bug.cgi?id=9320
> Handled-By	: Robert Moore <Robert.Moore@intel.com>
> 		  Tejun Heo <htejun@gmail.com>
> 		  Fu Michael <michael.fu@intel.com>
> Patch		: 
> 

A number of other people are seeing the same thing and Tejun is putting in
a blacklist of machines which cannot use libata+acpi.  That patch is not
yet in any git tree which I pull.

AFACIT the machines kepe working OK - there's just some nasty dmesg spew.

If any machines _are_ breaking then this could cause real problems and I'd
prefer that we either go for a whitelist or arrange to detect the condition
and fall back to non-acpi ata.

