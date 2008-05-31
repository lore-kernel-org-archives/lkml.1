Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbYEaQus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbYEaQus (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 12:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbYEaQuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 12:50:39 -0400
Received: from c60.cesmail.net ([216.154.195.49]:53450 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbYEaQui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 12:50:38 -0400
Subject: Re: Wireless-testing's b43 panics in b43_generate_txhdr on packet
	transmit
From: Pavel Roskin <proski@gnu.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200805311841.46740.mb@bu3sch.de>
References: <69e28c910805310723j2b721030x2609cc9e866abafa@mail.gmail.com>
	 <200805311711.16266.mb@bu3sch.de>
	 <69e28c910805310934w7d2bc2ddkec27926a8c8033c4@mail.gmail.com>
	 <200805311841.46740.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Date: Sat, 31 May 2008 12:50:36 -0400
Message-Id: <1212252636.2766.10.camel@rd>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-05-31 at 18:41 +0200, Michael Buesch wrote:
> On Saturday 31 May 2008 18:34:29 Stefanik Gábor wrote:
> > "BUG: unable to handle kernel NULL pointer dereference at 00000004
> > IP: [<f8dd3a99>] :b43:b43_generate_txhdr+0x6a9/0x790
> 
> So can you put a few printks into the function to see where it dereferences
> a NULL pointer? (or use gdb to lookup the offset).

u8 key_idx = info->control.hw_key->hw_key_idx;

info->control.hw_key is NULL.

-- 
Regards,
Pavel Roskin
