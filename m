Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbZGWQXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbZGWQXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 12:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbZGWQXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 12:23:43 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:38697 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbZGWQXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 12:23:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=kFH5rLq9b9guwz+PcC3xBgjpq+fSMGjFuB4TQocmVLm/hYk7d74YXJ6lZ7neLnzNC/
         N4xGPO29ifWZgw2xQwGk4P7x9BSuNJq89UxBhnBawBQ517NKZAoKtpCNpALDqICJRM/Z
         flusefT7p3Sfeivt9nYYkL+j8xOFJ/zl0yNbg=
Date: Thu, 23 Jul 2009 19:23:36 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Do cpu-endian MMIO accessors exist?
Message-ID: <20090723192336.721b9fb8@daedalus.pq.iki.fi>
In-Reply-To: <200907222319.12859.arnd@arndb.de>
References: <20090721234243.1928d9e2@daedalus.pq.iki.fi>
	<200907220001.59388.arnd@arndb.de>
	<20090722201148.19f47119@daedalus.pq.iki.fi>
	<200907222319.12859.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 23:19:12 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> > > It would of course be easy to just define an API extension
> > > to ioread along the lines of
> > > 
> > > #ifdef __BIG_ENDIAN
> > > #define ioread16_native ioread16be
> > > #define ioread32_native ioread32be
> > > #define iowrite16_native iowrite16be
> > > #define iowrite32_native iowrite32be
> > > #else
> > > #define ioread16_native ioread16
> > > #define ioread32_native ioread32
> > > #define iowrite16_native iowrite16
> > > #define iowrite32_native iowrite32
> > > #endif
> > > 
> > > but I'm not yet convinced that there is a potential user that
> > > should not just be fixed in a different way.
> > 
> > This is how it currently is.
> 
> Well, I meant we could add it to asm-generic/iomap.h. If we
> decide that this is the right approach after all, it should
> be part of the common linux API, not private to a single driver.

Yes, I understood. I believe I should wait until Nouveau gets ready
to be sent upstream before proposing your extension as a real patch.


Thank you very much.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
