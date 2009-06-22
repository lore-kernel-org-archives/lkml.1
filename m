Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbZFVUko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbZFVUko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbZFVUkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:40:31 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36235 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750997AbZFVUk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:40:29 -0400
X-Sasl-enc: Nkj2GLzlwOrEohQtpa3/Z4czAFhzgoE+gN5W51R1Zw0i 1245703231
Date: Mon, 22 Jun 2009 17:40:29 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Marco <marco.stornelli@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Tim Bird <tim.bird@am.sony.com>,
       Jamie Lokier <jamie@shareable.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
Message-ID: <20090622204028.GC29833@khazad-dum.debian.net>
References: <20090613155957.GA16220@shareable.org>
 <4A34A394.5040509@gmail.com>
 <20090621064040.GC1656@ucw.cz>
 <4A3E6F28.4090404@gmail.com>
 <20090621205245.GC3254@elf.ucw.cz>
 <2ea1731b0906212333r20deb71q2f021fc79bcc8a8e@mail.gmail.com>
 <20090622172003.GB21149@elf.ucw.cz>
 <4A3FBFF0.40006@am.sony.com>
 <20090622173704.GC21299@elf.ucw.cz>
 <4A3FC84A.6060608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3FC84A.6060608@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009, Marco wrote:
> I don't think, I think it's very clear:
> 
> "In summary, PRAMFS is a light-weight, full-featured, and
> space-efficient special filesystem that is ideal for systems with a
> block of fast non-volatile RAM that need to access data on it using a
> standard filesytem interface."

It is not full-featured if it doesn't have support for hardlinks, security
labels, extended attributes, etc.  Please call it a specialized filesystem
instead, that seems to be much more in line with the comments about pramfs
use cases in this thread...

Oh, and that should be in the Kconfig help text, as well as the stuff that
goes in Documentation/*, obviously.  Maybe it already is, I didn't look.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
