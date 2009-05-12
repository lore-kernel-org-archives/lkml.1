Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbZELKjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbZELKjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 06:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbZELKjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 06:39:21 -0400
Received: from main.gmane.org ([80.91.229.2]:52402 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbZELKjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 06:39:20 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Evgeni Golov <sargentd@die-welt.net>
Subject: Re: ath9k seems to be broken on 2.6.30-rc4 with a macbook pro
Date: Tue, 12 May 2009 12:39:03 +0200
Message-ID: <gubjk9$2rf$1@ger.gmane.org>
References: <dd18b0c30905111002y4aeb2033ma2fbb2730f5acdaf@mail.gmail.com>
	<4A089E49.7080403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
X-Gmane-NNTP-Posting-Host: 134.99.56.36
In-Reply-To: <4A089E49.7080403@gmail.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
X-Newsreader: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Cc: linux-kernel@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 23:53:13 +0200 Jiri Slaby wrote:

> > in dmesg I see:
> > 
> > [   36.337419] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 1
> > [   36.530106] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 2
> > [   36.730100] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 3
> > [   36.930101] wlan0: direct probe to AP 00:1e:2a:00:67:f0 timed out
> > [   44.421728] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 1
> > [   44.620080] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 2
> > [   44.820080] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 3
> > [   45.020076] wlan0: direct probe to AP 00:1e:2a:00:67:f0 timed out
> > 
> > The type of encryption used is just
> > a standard WEP key(no WPA).

Same here with 2.6.30-rc4, b43 and either Cisco (MAC-Addr starts with
00:40:96) or HP ProCurve (??? - they do WiFi? - MAC-Addr starts with
00:1F:FE) APs. No encryption, quite noisy environment (University).

No problem with ipw2200 (actually 2915) in the same hardware (Thinkpad
X31). Neither with the b43 and a standard Linksys WRT54GL (in the same!
noisy university-env).

Regards
Evgeni

