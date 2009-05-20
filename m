Return-Path: <linux-kernel-owner+w=401wt.eu-S1756450AbZETKEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbZETKEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 06:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141AbZETKE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 06:04:27 -0400
Received: from mailbox-us-s-12.mailhostingserver.com ([75.125.101.9]:58675
	"EHLO mailbox-us-s-12.mailhostingserver.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756070AbZETKEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 06:04:25 -0400
Date: Wed, 20 May 2009 12:04:23 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: Marcin Krol <mrkafk@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: inotify limits - thousands (tens of thousands?) of watches
Message-ID: <20090520100423.GA3695@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	Marcin Krol <mrkafk@gmail.com>, linux-kernel@vger.kernel.org
References: <4A13CCE1.5000106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A13CCE1.5000106@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, May 20, 2009 at 11:26:57AM +0200 Marcin Krol ha dit:

> First, apols for using up bandwidth, but I honestly found no other place  
> where I can ask about this (and get meaningful reply).
>
> I'm not a kernel programmer, but I want to develop a program that would  
> watch modifications in *all* user directories on a busy server using  
> inotify.
>
> This is for high-availability purposes - events would be collected and  
> once every several minutes changed dirs would be rsync'ed to failover  
> server or smth like that would be done.
>
> As inotify watches particular directory and not its subdirs, I would  
> have to watch all directories.
>
> This means I would have to create thousands or even tens of thousands of  
> inotify watches.
>
> So my questions are:
>
> 1. is it safe? that is, will it not lock the kernel up, or cause  
> excessive memory consumption?
>
> 2. is it economic in terms of CPU time and RAM? I have no idea how to  
> even measure such a thing happening in the kernel..

i can't answer your question whether inotify scales or not, but maybe
DRBD (http://en.wikipedia.org/wiki/DRBD) could be an alternative
approach for your problem

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

    Me lo contaron y lo olvidé, lo vi y lo entendí, lo hice y lo aprendí
                              (Confucio)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
