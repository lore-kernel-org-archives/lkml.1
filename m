Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbZJFFGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbZJFFGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 01:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbZJFFGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 01:06:37 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:59810 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbZJFFGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 01:06:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=qhju9kHAjX+xFXXyHgGJEygKMlfMQLFbRTN1f4dx1WZUErZf+sHY0ZmjpbHQ7KHUa5
         XUTNcsojRATY4ZzJ4a4N3IpKAVfXfvT4a48NmLy5JM+e3/3SthY+XNysdXNou/O3wXYs
         g9wKaHYdtogqbMf2j+cVQq2q1FlI0IAbgubQ4=
Date: Mon, 5 Oct 2009 22:05:51 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org
Subject: Re: [PATCH 05/34] move grover_remove to .devexit.text
Message-ID: <20091006050551.GA27881@core.coreip.homeip.net>
References: <20091001082607.GA2181@pengutronix.de> <1254385718-14254-5-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1254385718-14254-5-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 10:28:09AM +0200, Uwe Kleine-König wrote:
> The function grover_remove is used only wrapped by __devexit_p so define
> it using __devexit.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>

Folded together with your other patch to sparkspkr and applied.

Thanks Uwe.

-- 
Dmitry
