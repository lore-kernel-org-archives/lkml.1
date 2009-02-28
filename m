Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbZB1KPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbZB1KPj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 05:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbZB1KPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 05:15:30 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:38645 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbZB1KPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 05:15:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=ppFCu5IO3aT9oZCt2YJmHfRCkUXEgIoWmjNtCuWZ5dSmHSafpwSlQ2WLfuZl2s01Zw
         2Sb+nGOZLkjaw1hKZqsEv9BPRef6KTni9tZkW2/Lb5sOQNUFra7WAlqjrk7AikRrpFqq
         qiNo2aj4dn/WYN300TfHztAtWSKDMYaT1FxSk=
Date: Sat, 28 Feb 2009 11:15:24 +0100
From: Simon Kagstrom <simon.kagstrom@gmail.com>
To: Balaji Rao <balajirrao@openmoko.org>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andy Green <andy@openmoko.com>, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 2/2] spi_bitbang: Add support for non-blocking
 synchronous transfers
Message-ID: <20090228111524.1594a58e@lska2>
In-Reply-To: <20090228095846.GA32044@fedora.yogi>
References: <20090228081036.31964.80618.stgit@fedora.yogi>
	<20090228081117.31964.51155.stgit@fedora.yogi>
	<20090228100914.2ec2ff7f@lska2>
	<20090228095846.GA32044@fedora.yogi>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Feb 2009 15:28:48 +0530
Balaji Rao <balajirrao@openmoko.org> wrote:

> The master is not spi_s3c24xx but spi_s3x24xx_gpio, whose txrx are
> very simple code.
> 
> Additionally all of this has been tested and found to work. The code,
> along with the modified new spi based lis302dl driver is all in
> andy-tracking [1].

Oh, I didn't notice that. Nice then.

I see from the git logs that this and some other related patches have
been added now. Another question I have then is about the name: to me 
spi_non_blocking_transfer() sounds like it would do the opposite of
what I guess it does - it would go ahead without blocking on the call.

I guess what the name means is that it will not sleep during the call,
but for pushing it upstream, could it be better to name it something
else? Perhaps spi_sync and then rename the existing API name (which I
think is more than a bit strange), or maybe spi_sync_nowait or
something?

// Simon
