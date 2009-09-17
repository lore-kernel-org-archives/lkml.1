Return-Path: <linux-kernel-owner+w=401wt.eu-S933507AbZIQDZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933507AbZIQDZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 23:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758370AbZIQDZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 23:25:38 -0400
Received: from netrider.rowland.org ([192.131.102.5]:57959 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758284AbZIQDZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 23:25:37 -0400
Date: Wed, 16 Sep 2009 23:25:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jason Wessel <jason.wessel@windriver.com>
cc: gregkh@suse.de, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] usb console: fix mutex lock regression
In-Reply-To: <1253156887-31597-2-git-send-email-jason.wessel@windriver.com>
Message-ID: <Pine.LNX.4.44L0.0909162324460.24041-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009, Jason Wessel wrote:

> During the 2.6.32 development the use of serial->disc_mutex was
> introduced.  In usb_console_setup() the call to
> usb_serial_get_by_index() will obtain this mutex. The
> usb_console_setup() must release the mutex before it completes else
> later calls to the usb serial core will hang.

Apparently you didn't see my patch:

	http://marc.info/?l=linux-usb&m=125209260714221&w=2

Did this not get into linus-next?  Greg?

Alan Stern

