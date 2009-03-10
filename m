Return-Path: <linux-kernel-owner+w=401wt.eu-S1758082AbZCJRd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082AbZCJRd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756306AbZCJRdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:33:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39689 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756177AbZCJRdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:33:46 -0400
Date: Tue, 10 Mar 2009 17:34:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Valdis.Kletnieks@vt.edu
Cc: porte64@free.fr, linux-kernel@vger.kernel.org
Subject: Re: read-only partitions: does the policy apply to all metadata ?
Message-ID: <20090310173437.2a8114b2@lxorguk.ukuu.org.uk>
In-Reply-To: <29610.1236705759@turing-police.cc.vt.edu>
References: <355270241.1702481236702404399.JavaMail.root@spooler8-g27.priv.proxad.net>
	<29610.1236705759@turing-police.cc.vt.edu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009 13:22:39 -0400
Valdis.Kletnieks@vt.edu wrote:

> On Tue, 10 Mar 2009 17:26:44 BST, porte64@free.fr said:
> > When a partition is mounted as read-only, does the kernel
> > really prevent ANY byte to be written to it, including
> > any metadata ?
> 
> It's very hard to come up with a workable way to do a true read-only
> mount of a journaled filesystem such as ext3 - what do you do if there's
> anything in the journal that needs to be replayed?

Replay it to a snapshot backed by the r/o fs ...
