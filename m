Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbYGILhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbYGILhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbYGILgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:36:54 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:45824 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbYGILgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:36:53 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: 2.6.25: random stalls on certain hardware - regression?
Date: Wed, 9 Jul 2008 13:37:31 +0200
User-Agent: KMail/1.9.9
Cc: "Linux-kernel" <linux-kernel@vger.kernel.org>
References: <4873E27C.6050504@msgid.tls.msk.ru> <200807091032.14786.oliver@neukum.org> <48748340.1060603@msgid.tls.msk.ru>
In-Reply-To: <48748340.1060603@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807091337.32118.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 09 Juli 2008 11:22:08 schrieb Michael Tokarev:
> Oliver Neukum wrote:
> > Am Dienstag 08 Juli 2008 23:56:12 schrieb Michael Tokarev:
> > 
> >> Any idea how to start welcome.  Meanwhile I'll try current 2.6.26pre,
> >> in a hope it will not destroy all our data.. ;)
> > 
> > Can you test whether select() triggers the lockup?
> 
> Hmm.  Sure I can, and it definitely uses select() here and there -
> samba & Oracle8 & cronyd & vtund & syslogd - that's services
> running on it all using select(2).  Can you elaborate a bit
> more on this please?  I mean, should it lock up on first select()
> (so that it's not what I see here) or on some random one (still

select() but not necessary the first call. I've got a report which seems
to indicate a rogue pointer while building the poll table. You might
strace a test programm and see whether it hangs in select() if it manages
to trigger the lockup.

	Regards
		Oliver
