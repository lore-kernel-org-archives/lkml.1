Return-Path: <linux-kernel-owner+w=401wt.eu-S1758358AbYDOH2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbYDOH2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 03:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbYDOH2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 03:28:12 -0400
Received: from phoenix.slamd64.com ([217.10.145.2]:56157 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbYDOH2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 03:28:11 -0400
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 4/8] rfkill: add read-write rfkill switch support
Date: Tue, 15 Apr 2008 08:27:49 +0100
User-Agent: KMail/1.9.9
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <200804142006.51224.carlos@strangeworlds.co.uk> <20080414162209.ZZRA012@mailhub.coreip.homeip.net>
In-Reply-To: <20080414162209.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804150827.49936.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Tue, 15 Apr 2008 07:27:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 April 2008 21:23:14 Dmitry Torokhov wrote:
> On Mon, Apr 14, 2008 at 08:06:50PM +0100, Carlos Corbacho wrote:
> > I agree wholeheartedly with Henrique here though - wireless drivers
> > should _not_ be using key press events as a reporting mechanism.
>
> Reporting mechanism for what exacly though? Depending on what you are
> talking about we either agree or disagree here ;)

Reporting state change in this case. For instance, KEY_WLAN means exactly 
that - a user pressed a key that was mapped to KEY_WLAN. It's not a generic 
notifier for any and all wireless events, state changes, etc.

If wireless drivers want to report a state change, then we need a proper 
mechanism for that, as has already been discussed by Henrique.

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
