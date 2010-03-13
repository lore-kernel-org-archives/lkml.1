Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934786Ab0CMJ4e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 04:56:34 -0500
Received: from mail-yx0-f174.google.com ([209.85.210.174]:43413 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933495Ab0CMJ4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 04:56:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V4mHjf8XJ2rbEmZXYxjJw8fbtOuN0dyMRmfVr2adX5ghOM0qSN9Wx6re7f3Azn6hRs
         HXaIMHVC54XXC2RLfOr12RmBKmdaR06kDTjxshNfyKe9A8BbpH7ETI+uqMtVjukDVzsC
         7ui7ry/0u+Cg/LdYfGU1wLO4ABTY7/+PVP+BM=
Date: Sat, 13 Mar 2010 01:56:27 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: florian@mickler.org
Cc: "John W. Linville" <linville@tuxdriver.com>, Valdis.Kletnieks@vt.edu,
       Marcel Holtmann <marcel@holtmann.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Johannes Berg <johannes@sipsolutions.net>,
       linux-wireless@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] rename new rfkill sysfs knobs
Message-ID: <20100313095626.GB16038@core.coreip.homeip.net>
References: <20100313104128.79aa2846@schatten.dmk.lab>
 <1268473447-28669-1-git-send-email-florian@mickler.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268473447-28669-1-git-send-email-florian@mickler.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 13, 2010 at 10:44:07AM +0100, florian@mickler.org wrote:
> This patch renames the (never officially released) sysfs-knobs
> "blocked_hw" and "blocked_sw" to "hard" and "soft", as the hardware vs
> software conotation is misleading.
> 
> It also gets rid of not needed locks around u32-read-access.

You could also drop temporaries as well.

-- 
Dmitry
