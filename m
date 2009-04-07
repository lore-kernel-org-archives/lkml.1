Return-Path: <linux-kernel-owner+w=401wt.eu-S1760937AbZDGTFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760937AbZDGTFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 15:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbZDGTEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 15:04:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55246 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619AbZDGTEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 15:04:48 -0400
Date: Tue, 7 Apr 2009 13:04:03 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: "John Stoffel" <john@stoffel.org>
Cc: Jarek Poplawski <jarkao2@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-usb@vger.kernel.org, zaitcev@redhat.com
Subject: Re: usb_mon oops Re: tcpdump crashes 2.6.29.1 (and 2.6.29-rc5)
Message-Id: <20090407130403.e0061a8d.zaitcev@redhat.com>
In-Reply-To: <18907.28788.965069.573489@stoffel.org>
References: <18906.49779.243047.207639@stoffel.org>
	<20090407120022.GA6519@ff.dom.local>
	<18907.28788.965069.573489@stoffel.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009 11:25:40 -0400, "John Stoffel" <john@stoffel.org> wrote:

> But I'm surprised that USB_MON would be the cause when it's a
> networking tool which is starting up?  *shrug*

The libpcap supports usbmon. Perhaps it scans something.

The big problem with usbmon is, it has to trust what drivers
stuff into URBs. Bet it's your uvcvideo. A rough driver, that.

-- Pete
