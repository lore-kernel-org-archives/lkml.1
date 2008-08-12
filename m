Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbYHLMRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbYHLMRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 08:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYHLMRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 08:17:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33284 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751892AbYHLMRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 08:17:36 -0400
Date: Tue, 12 Aug 2008 13:00:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [patch 1/2] fastboot: Add a module parameter to skip probing of
 specific ports
Message-ID: <20080812130027.2c4643a9@lxorguk.ukuu.org.uk>
In-Reply-To: <20080812043603.3d8471d4@infradead.org>
References: <20080811153542.61095e5c@infradead.org>
	<20080811153641.706726ec@infradead.org>
	<20080812083903.6d402c2e@lxorguk.ukuu.org.uk>
	<20080812043603.3d8471d4@infradead.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > What
> > defines the probe order here particularly as people are pushing for
> > parallel probing of multiple devices.
> 
> the patches I'm pushing for this don't change probe order; that has
> been tried before and wasn't a great success.

That was a question sorry. You are sledgehammering controllers by
discovery sequence - you've no idea if they will always be found in that
order. As such your boot option is incredibly fragile.
