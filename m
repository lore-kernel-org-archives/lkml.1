Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbZLCKxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbZLCKxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 05:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbZLCKxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 05:53:51 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:45384 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbZLCKxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 05:53:50 -0500
Date: Thu, 3 Dec 2009 11:53:47 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Message-ID: <20091203105347.GB12943@gundam.enneenne.com>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Dave Jones <davej@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
	Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
	Kay Sievers <kay.sievers@vrfy.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Christoph Hellwig <hch@infradead.org>
References: <1259774329-29663-1-git-send-email-giometti@linux.it> <1259774329-29663-2-git-send-email-giometti@linux.it> <1259774329-29663-3-git-send-email-giometti@linux.it> <1259774329-29663-4-git-send-email-giometti@linux.it> <1259774329-29663-5-git-send-email-giometti@linux.it> <1259774329-29663-6-git-send-email-giometti@linux.it> <1259774329-29663-7-git-send-email-giometti@linux.it> <20091202185903.66e6709e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202185903.66e6709e@lxorguk.ukuu.org.uk>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 06/11] pps: serial clients support.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 06:59:03PM +0000, Alan Cox wrote:
> On Wed,  2 Dec 2009 18:18:44 +0100
> Rodolfo Giometti <giometti@linux.it> wrote:
> 
> > Adds support, by using the PPS line discipline, for the PPS sources
> > connected with the CD (Carrier Detect) pin of a serial port.
> 
> I would suggest one change here - but the pps-ldisc bits into the n_tty.c
> file then you don't have to export everything. That or just export the
> n_tty ops struct.
> 
> I think putting the pps ldisc (which is basically n_tty and a bit) into
> n_tty is probably the right choice given how small and clean it is - what
> do you think ?

I think it could be ok, but in this case where should I register
pps-ldisc? Into tty_ldisc_begin just after tty_ldisc_N_TTY?

Again, should I remove the possibility to compile pps-ldisc as module?

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
