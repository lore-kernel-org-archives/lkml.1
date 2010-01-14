Return-Path: <linux-kernel-owner+w=401wt.eu-S932233Ab0ANVHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab0ANVHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 16:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206Ab0ANVHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 16:07:47 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58402 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752688Ab0ANVHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 16:07:46 -0500
X-Sasl-enc: JuWzx+cH2kgDsDaulnHQ80JSgW7nMVJ/Mlh3FDd7h1hq 1263503264
Date: Thu, 14 Jan 2010 19:07:43 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver-Core: devtmpfs - reset inode permissions before
 unlinking
Message-ID: <20100114210743.GE3814@khazad-dum.debian.net>
References: <1263388596.26006.1.camel@yio.site>
 <20100114205304.GC3814@khazad-dum.debian.net>
 <ac3eb2511001141259t751c6063p8919692a8164e2b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2511001141259t751c6063p8919692a8164e2b@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010, Kay Sievers wrote:
> On Thu, Jan 14, 2010 at 21:53, Henrique de Moraes Holschuh
> <hmh@hmh.eng.br> wrote:
> > On Wed, 13 Jan 2010, Kay Sievers wrote:
> >> across the device lifetime by creating hardlinks, in the unusual case
> >> that there is a user-writable directory on the same filesystem.
> >
> > Does a tmpfs mounted in /dev/shm count as "user-writable directory on the
> > same filesystem" ?
> 
> Not if it's a separate tmpfs mount, which is recommended. Only if it's
> just a plain directory on the /dev filesystem.

Yeah, I noticed the abusurdity of my question when I re-read it, thanks for
being kind in the reply.

That said, this does fix a possible security problem when a misconfigured
system is used, and the fix looks rather simple...  Can it go to -stable
eventually, even if it is months in the future, after it gets some testing
in .34 ?   Minor problems are still problems...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
