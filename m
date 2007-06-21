Return-Path: <linux-kernel-owner+w=401wt.eu-S1757107AbXFUTOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107AbXFUTOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbXFUTOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:14:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:52144 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbXFUTOj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:14:39 -0400
From: Hans-Peter Jansen <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that through other means
Date: Thu, 21 Jun 2007 21:14:24 +0200
User-Agent: KMail/1.9.5
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Dr. David Alan Gilbert" <linux@treblig.org>,
       Karel Zak <kzak@redhat.com>, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
References: <467994BD.6000403@zytor.com> <20070620224135.GC6258@gallifrey> <4679AE5E.4050001@zytor.com>
In-Reply-To: <4679AE5E.4050001@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706212114.25705.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX19Xs8DUhPn65AF3t+z6dMqUnhyKlhJBte/0N39
 F7H9hTVMVLU+2YxOt3xEqWDKW01NUMelhmcOoVXaIfndI5m6g5
 KTHn39YbnWYzCLOc0T2Bw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 21. Juni 2007 00:46 schrieb H. Peter Anvin:
> Dr. David Alan Gilbert wrote:
> > What happens with the (sick) case of spaces in directory names?
> > Also is it really nicely defined that there is no way to put a space
> > in an option in any of the filesystems?   I suppose someone
> > particularly sick could have a device node in a directory with a space
> > in it.  It would be nice if new formats for this are being defined
> > to make it cover everything.
>
> That's already handled just fine:
>
> bash-3.1$ mkdir /tmp/'Jag är: \
> en liten mask'
> bash-3.1$ sudo mount -t tmpfs none '/tmp/Jag är: \
> en liten mask'/
> bash-3.1$ tail -1 /proc/mounts
> none /tmp/Jag\040är:\040\134\012en\040liten\040mask tmpfs rw 0 0
> bash-3.1$

Hmm, and what about the even sicker case: /tmp/\040, parse as /tmp/\\040?
Do userspace cope with this?

Happy parsingly y'rs,
  Pete
