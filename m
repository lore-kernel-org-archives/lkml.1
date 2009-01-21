Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbZAUWnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbZAUWnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 17:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbZAUWnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 17:43:37 -0500
Received: from hiauly1.hia.nrc.ca ([132.246.100.193]:4562 "EHLO
	hiauly1.hia.nrc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbZAUWnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 17:43:37 -0500
Subject: Re: Confusion in usr/include/asm-generic/fcntl.h
To: grundler@parisc-linux.org (Grant Grundler)
Date: Wed, 21 Jan 2009 17:43:34 -0500 (EST)
From: "John David Anglin" <dave@hiauly1.hia.nrc.ca>
Cc: arnd@arndb.de, davem@davemloft.net, jaswinder@kernel.org, mingo@elte.hu,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org
In-Reply-To: <20090121222522.GB15211@colo.lackof.org> from "Grant Grundler" at Jan 21, 2009 03:25:22 pm
X-Mailer: ELM [version 2.4 PL25]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-Id: <20090121224335.099C94F30@hiauly1.hia.nrc.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > CONFIG_64BIT on parisc user space looks very wrong.
> 
> This shouldn't be exported to user space. Is that what you meant?

This does get exported to user space as applications sometimes need
to know whether they are running under a 32 or 64-bit kernel.  See
config.guess.  However, it certainly would be wrong to use this
to make decisions about user space.

Dave
-- 
J. David Anglin                                  dave.anglin@nrc-cnrc.gc.ca
National Research Council of Canada              (613) 990-0752 (FAX: 952-6602)
