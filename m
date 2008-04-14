Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbYDNEWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbYDNEWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 00:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbYDNEWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 00:22:42 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:30306 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbYDNEWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 00:22:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=XQsOOh+JxUJnix2qenwVxfqmfXzUNNPDbBb8QkFAas37irv3Q+IRxqNNyTy+nWWsKNu5xNXpl9EFY5VE/6ijfmLOItL9wt0CpVUYCmTfFYuKQr7w5GMqGGYT35QQhUeW1zZKOPx89FyKTixd8Cxmw6xXO6hIM6EOOuKpzeuw+a8=
Date: Mon, 14 Apr 2008 00:22:34 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/8] rfkill: clarify meaning of rfkill states
Message-ID: <20080414042234.GC655@anvil.corenet.prv>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <1207946244-14525-2-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207946244-14525-2-git-send-email-hmh@hmh.eng.br>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 05:37:17PM -0300, Henrique de Moraes Holschuh wrote:
> rfkill really should have been named rfswitch.  As it is, one can get
> confused whether RFKILL_STATE_ON means the KILL switch is on (and
> therefore, the radio is being *blocked* from operating), or whether it
> means the RADIO rf output is on.
> 
> Clearly state that RFKILL_STATE_ON means the radio is *unblocked* from
> operating (i.e. there is no rf killing going on).
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: Dmitry Torokhov <dtor@mail.ru>

I consider Ivo maintaining rfkill but for what it worth:

Acked-by: Dmitry Torokhov <dtor@mail.ru>

-- 
Dmitry
