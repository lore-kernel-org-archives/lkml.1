Return-Path: <linux-kernel-owner+w=401wt.eu-S1754380AbYE1TMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbYE1TMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 15:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYE1TL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 15:11:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48063 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752676AbYE1TL4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 15:11:56 -0400
Date: Wed, 28 May 2008 19:57:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Jens =?UTF-8?B?QsOkY2ttYW4=?=" <jens.backman@gmail.com>
Cc: "Justin Piszcz" <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
Message-ID: <20080528195752.0cdcbc6d@core>
In-Reply-To: <95711f160805280934y77ed7d91tec5aeb531bf8013c@mail.gmail.com>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>
	<95711f160805280934y77ed7d91tec5aeb531bf8013c@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008 18:34:00 +0200
"Jens Bäckman" <jens.backman@gmail.com> wrote:

> On Wed, May 28, 2008 at 10:53 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> > Results:
> >
> > http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.html
> > http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.txt
> 
> Either the RAID 1 read speed must be wrong, or something is odd in the
> Linux implementation. There's six drives that can be used for reading
> at the same time, as they contain the very same data. 63MB/s
> sequential looks like what you would get from a single drive.

Which is fairly typical of a cheap desktop PC where the limitation is the
memory and PCI bridge as much as the drive.

Alan
