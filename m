Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbYIUX1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbYIUX1Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 19:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYIUX04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 19:26:56 -0400
Received: from senator.holtmann.net ([87.106.208.187]:52948 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbYIUX0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 19:26:55 -0400
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware
	restart.
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, ipw2100-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, yi.zhu@intel.com,
       reinette.chatre@intel.com, jgarzik@pobox.com, linville@tuxdriver.com,
       davem@davemloft.net
In-Reply-To: <20080921210554.GA2135@2ka.mipt.ru>
References: <20080921182835.GA11473@2ka.mipt.ru>
	 <20080921113513.16677c4e@infradead.org>
	 <20080921190050.GA20484@2ka.mipt.ru>
	 <1222024444.3023.53.camel@johannes.berg>
	 <20080921193809.GA8735@2ka.mipt.ru> <20080921124332.67ddc13a@infradead.org>
	 <20080921202057.GB25052@2ka.mipt.ru>
	 <20080921132753.5689b564@infradead.org>
	 <20080921205706.GA24545@2ka.mipt.ru>
	 <20080921140203.4698a2ee@infradead.org> <20080921210554.GA2135@2ka.mipt.ru>
Content-Type: text/plain
Date: Mon, 22 Sep 2008 01:27:47 +0200
Message-Id: <1222039667.6782.125.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Evgeniy,

> > > That allows to dump whatever number of warnings you want. The more we
> > > have, the louder will be customers scream.
> > 
> > artificially increasing numbers isn't going to do that; it just shows
> > you're more interested in making a stink than in getting something
> > improved ;(
> 
> As practice shows, I'm the only one who is interested in getting
> something improved, and Intel, as we see right now, is not interested in
> it at all, since you ask me not only decrease error verbosity, but also
> do not work towards fixing the bug by trying to understand where it
> lives.

as Arjan and Alan pointed out already, WARN_ON_ONCE is enough and I
agree with them. Just to make this perfectly clear, this is with my
community hat on.

Please send a proper patch with a simple WARN_ON_ONCE and I am happy to
sign off on it.

Regards

Marcel


