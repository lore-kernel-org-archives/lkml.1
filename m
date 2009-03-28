Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbZC1AYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbZC1AYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 20:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbZC1AYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 20:24:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42357
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751837AbZC1AYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 20:24:38 -0400
Date: Fri, 27 Mar 2009 17:24:25 -0700 (PDT)
Message-Id: <20090327.172425.30448517.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: Re: netrom: zero length frame filtering in NetRom
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090328002137.52558018@lxorguk.ukuu.org.uk>
References: <20090327102823.3c485bfc@lxorguk.ukuu.org.uk>
	<20090327.143406.192730131.davem@davemloft.net>
	<20090328002137.52558018@lxorguk.ukuu.org.uk>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Sat, 28 Mar 2009 00:21:37 +0000

> On Fri, 27 Mar 2009 14:34:06 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
> > I'll back them both out which is what I assume you want me to
> > do.
> 
> Yes. Handling zero length frames with socket API is nasty and ugly but
> unfortunately its a valid use of these protocols. I need to go read the
> AF_ROSE docs to double check the situation with ROSE but the other two
> definitely want backing out.

Ok, both reverted, thanks.
