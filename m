Return-Path: <linux-kernel-owner+w=401wt.eu-S1757754AbYLLE2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbYLLE2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 23:28:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756240AbYLLE2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 23:28:47 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:47046 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229AbYLLE2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 23:28:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hPAyPnZgk5JeV+m4r2rv6CDxzbnWtahNLrPirGrBwoBTw5Mu77l49+rFnjhRG7FD5+
         SNkd1FKW43YrNuIY3TN3KbXng+7k8mc7QwJ0G0IDa7uncgpBrlJSYcFUyjhLYfdB4mk0
         p1B3k79gxBci8L4fDhgx7OwWxR3cWyTMh4/20=
Date: Fri, 12 Dec 2008 07:25:03 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: rydberg@bitmath.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, mjg@redhat.com, nicolas@boichat.ch,
       rydberg@euromail.se, linux-kernel@vger.kernel.org
Subject: Re: [patch 18/19] Define MODULE_SYSTEM_TABLE for mbp_nvidia_bl.o
	and applesmc.o
Message-ID: <20081212042503.GA14668@x200.localdomain>
References: <200812092114.mB9LETsI027215@imap1.linux-foundation.org> <493F1C96.5070400@bitmath.org> <200812120305.mBC35vh8078366@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812120305.mBC35vh8078366@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -MODULE_DEVICE_TABLE(dmi, applesmc_whitelist);
> +MODULE_SYSTEM_TABLE(dmi, applesmc_whitelist);

I sent patch which does "#define dmi_device_id dmi_system_id" and thus
avoids yet another wrapper.
