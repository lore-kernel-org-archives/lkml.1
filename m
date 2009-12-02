Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbZLBS6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbZLBS6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 13:58:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbZLBS6C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 13:58:02 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44954 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753696AbZLBS6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 13:58:01 -0500
Date: Wed, 2 Dec 2009 18:59:03 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Rodolfo Giometti <giometti@linux.it>
Subject: Re: [PATCH 06/11] pps: serial clients support.
Message-ID: <20091202185903.66e6709e@lxorguk.ukuu.org.uk>
In-Reply-To: <1259774329-29663-7-git-send-email-giometti@linux.it>
References: <1259774329-29663-1-git-send-email-giometti@linux.it>
	<1259774329-29663-2-git-send-email-giometti@linux.it>
	<1259774329-29663-3-git-send-email-giometti@linux.it>
	<1259774329-29663-4-git-send-email-giometti@linux.it>
	<1259774329-29663-5-git-send-email-giometti@linux.it>
	<1259774329-29663-6-git-send-email-giometti@linux.it>
	<1259774329-29663-7-git-send-email-giometti@linux.it>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 Dec 2009 18:18:44 +0100
Rodolfo Giometti <giometti@linux.it> wrote:

> Adds support, by using the PPS line discipline, for the PPS sources
> connected with the CD (Carrier Detect) pin of a serial port.

I would suggest one change here - but the pps-ldisc bits into the n_tty.c
file then you don't have to export everything. That or just export the
n_tty ops struct.

I think putting the pps ldisc (which is basically n_tty and a bit) into
n_tty is probably the right choice given how small and clean it is - what
do you think ?
