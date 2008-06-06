Return-Path: <linux-kernel-owner+w=401wt.eu-S1765236AbYFFQ64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765236AbYFFQ64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYFFQ6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:58:46 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2833 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755467AbYFFQ6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:58:45 -0400
Date: Fri, 6 Jun 2008 12:23:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc
Message-ID: <20080606162324.GB635@tuxdriver.com>
References: <20080601193000.GA3056@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080601193000.GA3056@ime.usp.br>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2008 at 04:30:01PM -0300, Rogério Brito wrote:
> Hi.
> 
> I have an iBook G3 600MHz combo (late 2001 model, powerpc) with a USB
> wireless card rt2x00 that doesn't work.
> 
> I just compiled a fresh 2.6.26-rc4 kernel and it can't get a lease from
> the access point, even though it is able to see the access point.
> 
> The userland here is Debian unstable (sid) and I can perform some of the
> steps in the direction of configuring the interface. For instance, the
> following works (I am using wep as the encryption system with other systems
> running under Linux, but, unfortunately, EVEN disabling encryption for the
> sake of the tests doesn't help here):
> 
> *insert USB card*
> ifconfig wlan0 up
> iwconfig wlan0 essid "default"
> iwconfig wlan0 s:my-key
> iwconfig wlan0 ap any
> (Here it shows that it can see the access point)
> dhclient wlan0
> (Here, it is unable to grab an IP addess from the access point)

You should set the key _before_ setting the essid.

John
-- 
John W. Linville
linville@tuxdriver.com
