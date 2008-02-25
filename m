Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbYBYTru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbYBYTru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 14:47:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbYBYTrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 14:47:41 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755351AbYBYTrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 14:47:40 -0500
Date: Mon, 25 Feb 2008 11:46:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Len Brown" <len.brown@intel.com>, linux-acpi@vger.kernel.org
Subject: Re: new regression in 2.6.25-rc3: no keyboard/lid acpi events on
 thinkpad T61p
Message-Id: <20080225114611.d91791f6.akpm@linux-foundation.org>
In-Reply-To: <8f53421d0802251119q470a79c1p31048ef136271f84@mail.gmail.com>
References: <8f53421d0802251119q470a79c1p31048ef136271f84@mail.gmail.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008 21:19:24 +0200 "Michael S. Tsirkin" <m.s.tsirkin@gmail.com> wrote:

> On my T61p, 2.6.25-rc2 seems to get acpi events from keypresses
> such as Fn-F4 and lid open/close, prints them in /var/log/acpid
> and reacts accordingly (my acpi scripts suspend on lid close and Fn-F4).

You mean suspend-to-ram works correctly on your t61p?

Mine suspends, then five seconds later magically resumes itself and the
screen is all black.

