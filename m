Return-Path: <linux-kernel-owner+w=401wt.eu-S1755589AbYEaUtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbYEaUtq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 16:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbYEaUtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 16:49:35 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:55689 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbYEaUte convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 16:49:34 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Stefanik =?iso-8859-1?q?G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: Wireless-testing's b43 panics in b43_generate_txhdr on packet transmit
Date: Sat, 31 May 2008 22:48:55 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
       "Pavel Roskin" <proski@gnu.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>,
       linux-kernel@vger.kernel.org
References: <69e28c910805310723j2b721030x2609cc9e866abafa@mail.gmail.com> <1212265322.7672.2.camel@johannes.berg> <69e28c910805311329v8f29c42mbb97ab553cc6e96c@mail.gmail.com>
In-Reply-To: <69e28c910805311329v8f29c42mbb97ab553cc6e96c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805312248.55551.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 May 2008 22:29:13 Stefanik Gábor wrote:
> On Sat, May 31, 2008 at 10:22 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Sat, 2008-05-31 at 19:54 +0200, Michael Buesch wrote:
> >> On Saturday 31 May 2008 18:50:36 Pavel Roskin wrote:
> >> > On Sat, 2008-05-31 at 18:41 +0200, Michael Buesch wrote:
> >> > > On Saturday 31 May 2008 18:34:29 Stefanik Gábor wrote:
> >> > > > "BUG: unable to handle kernel NULL pointer dereference at 00000004
> >> > > > IP: [<f8dd3a99>] :b43:b43_generate_txhdr+0x6a9/0x790
> >> > >
> >> > > So can you put a few printks into the function to see where it dereferences
> >> > > a NULL pointer? (or use gdb to lookup the offset).
> >> >
> >> > u8 key_idx = info->control.hw_key->hw_key_idx;
> >> >
> >> > info->control.hw_key is NULL.
> >>
> >> Is a NULL pointer supposed to tell "do not encrypt", or is this a mac80211 bug?
> >
> > It's probably a bug.
> >
> > johannes
> >
> 
> Should we assume that it's the first key if it happens?

No. It looks like it should not happen at all.


-- 
Greetings Michael.
