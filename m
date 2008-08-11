Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbYHKP05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbYHKP05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYHKP0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:26:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62144 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbYHKP0s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:26:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [RFC][PATCH 1/4] checkpoint-restart: general infrastructure
Date: Mon, 11 Aug 2008 17:25:13 +0200
User-Agent: KMail/1.9.9
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org
References: <20080807224033.FFB3A2C1@kernel> <1218234411.19082.58.camel@nimitz> <20080811150703.GA25930@us.ibm.com>
In-Reply-To: <20080811150703.GA25930@us.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808111725.13635.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+NCMJ1PCulf7MR1QRrxrkpnFIPPM7n8s4RXd0
 5Qu+4TZZhXFI75uXqt7G28zPY89zyEImnUZ+cqfw0dJPTkCoZQ
 M0lIA8HGbtu0Tomw80ueg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 August 2008, Serge E. Hallyn wrote:
> One reason is that I suspect that stops us from being able to send that
> data straight to a pipe to compress and/or send on the network, without
> hitting local disk.  Though if the checkpointfs was ram-based maybe not?
> 
> As Oren has pointed out before, passing in an fd means we can pass a
> socket into the syscall.
> 
> Using the anon_inodes would also prevent that, but if it makes for a
> cleaner overall solution then I'm not against considering either one
> of course.
> 

With anon_inodes, you can still implement splice_read/splice_write,
so you can splice it into a socket.

	Arnd <><
