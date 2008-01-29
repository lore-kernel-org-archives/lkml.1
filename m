Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbYA2KKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbYA2KKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 05:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbYA2KKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 05:10:34 -0500
Received: from nn7.de ([85.214.94.156]:60552 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbYA2KKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 05:10:33 -0500
Subject: Re: 24rc8: unregister_netdevice: waiting for ... to become free.
	Usage count = 1?
From: Soeren Sonnenburg <kernel@nn7.de>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080122.224442.142676954.davem@davemloft.net>
References: <1201070541.22958.53.camel@localhost>
	 <20080122.224442.142676954.davem@davemloft.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 29 Jan 2008 09:59:10 +0100
Message-Id: <1201597150.4973.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-22 at 22:44 -0800, David Miller wrote:
> From: Soeren Sonnenburg <kernel@nn7.de>
> Date: Wed, 23 Jan 2008 07:42:21 +0100
> 
> > Dear all,
> > 
> > since some 2.6.24rc version I suddenly experience such messages on
> > console when trying to shutdown a vpn connection:
> > 
> > unregister_netdevice: waiting for tun0 to become free. Usage count = 1
> > 
> > or when removing an usb wlan dongle (although it was ifconfig wlan0
> > down'd before)
> 
> Current GIT already has a fix for this, attached below:

hmmhhh, I am still seeing this problem on 2.6.24 with at least with the
madwifi driver...

Soeren
