Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbYLDJiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbYLDJiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 04:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbYLDJh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 04:37:58 -0500
Received: from smtp.nokia.com ([192.100.122.233]:20694 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbYLDJh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 04:37:57 -0500
Date: Thu, 4 Dec 2008 11:37:15 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Kwangwoo Lee <kwangwoo.lee@gmail.com>
Cc: felipe.balbi@nokia.com, ext Trilok Soni <soni.trilok@gmail.com>,
       dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>,
       "linux-omap@vger.kernel.org Mailing List" 
	<linux-omap@vger.kernel.org>
Subject: Re: [PATCH] Add tsc2007 based touchscreen driver.
Message-ID: <20081204093715.GH10209@gandalf.research.nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <483a38b80812020539v2323a784h7f202749687764db@mail.gmail.com> <5d5443650812030321p77c4941cj2202418f0b0d44a2@mail.gmail.com> <20081203120144.GA10123@gandalf.research.nokia.com> <483a38b80812032107i761fb9bdkba9b2ce5e998ae6a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483a38b80812032107i761fb9bdkba9b2ce5e998ae6a@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 04 Dec 2008 09:37:38.0845 (UTC) FILETIME=[F25E4CD0:01C955F3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 02:07:30PM +0900, ext Kwangwoo Lee wrote:
> Because the platform which I use did not implement smbus_xfer yet,
> it only implemented  master_xfer in struct i2c_algorithm.
> I can add smbus_xfer for my platform. I have one question and
> I know that smbus is a subset from the I2C protocol.
> Is smbus_xfer method better than master_xfer or is there any
> special reason to use smbus_xfer?

i2c subsystem has smbus emulation. The special reason is just that it's
simpler for the driver writer ;-)

-- 
balbi
