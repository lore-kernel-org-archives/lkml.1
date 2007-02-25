Return-Path: <linux-kernel-owner+w=401wt.eu-S932166AbXBYXzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbXBYXzF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 18:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932315AbXBYXzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 18:55:05 -0500
Received: from coyote.holtmann.net ([217.160.111.169]:49588 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166AbXBYXzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 18:55:03 -0500
Subject: Re: [RFC][PATCH 6/7] Freezer: Remove PF_NOFREEZE from bluetooth
	threads
From: Marcel Holtmann <marcel@holtmann.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
       ego@in.ibm.com, akpm@osdl.org, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       Pavel Machek <pavel@ucw.cz>, Aneesh Kumar <aneesh.kumar@gmail.com>,
       bluez-devel@lists.sourceforge.net
In-Reply-To: <200702231125.43910.rjw@sisk.pl>
References: <200702231116.23607.rjw@sisk.pl>
	 <200702231125.43910.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 00:53:41 +0100
Message-Id: <1172447621.20450.21.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Remove PF_NOFREEZE from the bluetooth threads, adding try_to_freeze() calls as
> required.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  net/bluetooth/bnep/core.c   |    6 ++++--
>  net/bluetooth/cmtp/core.c   |    4 +++-
>  net/bluetooth/hidp/core.c   |    4 +++-
>  net/bluetooth/rfcomm/core.c |    4 +++-
>  4 files changed, 13 insertions(+), 5 deletions(-)

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

for the Bluetooth part of this patch series.

Regards

Marcel


