Return-Path: <linux-kernel-owner+w=401wt.eu-S932205AbYFKR4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbYFKR4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 13:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765130AbYFKRzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 13:55:55 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:4419 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757907AbYFKRzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 13:55:54 -0400
Date: Wed, 11 Jun 2008 19:58:27 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jean Delvare <khali@linux-fr.org>, Krzysztof Helt <krzysztof.h1@wp.pl>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       lm-sensors@lm-sensors.org, rh1985@wp.pl
Subject: Re: [PATCH] Unhide the SMBus on the Compaq Deskpro EN
Message-Id: <20080611195827.11e51c39.krzysztof.h1@poczta.fm>
In-Reply-To: <200806110916.38694.jbarnes@virtuousgeek.org>
References: <20080608134702.401b9fb5.krzysztof.h1@wp.pl>
	<200806101202.20257.jbarnes@virtuousgeek.org>
	<20080611165324.6c080efb@hyperion.delvare>
	<200806110916.38694.jbarnes@virtuousgeek.org>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: c2e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008 09:16:38 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Wednesday, June 11, 2008 7:53 am Jean Delvare wrote:
> > BTW, Krzysztof, what about adding (read-only) support for the critical
> > limits to your thmc50 driver? It would be helpful in a situation like
> > this.
> >

I'll try to add this and support for adm1028/thmc51 chips.

> > Another thing to check is whether the value of register 0x19 (analog
> > output) changes automatically when the fan speeds up.
> >
> > Until these tests are done, I consider this patch possibly unsafe and
> > not ready to go to Linus (although probably OK for -next).
> 
> Ok, thanks for the heads up Jean, I'll keep this one out of the queue I send 
> to Linus until we get confirmation about its safety.
> 

I should be able to confirm in about a week. Two guys are currently using
the patch with thmc50 sensor driver. 

Regards,
Krzysztof


----------------------------------------------------------------------
Podbij Dziki Zachod!Gra strategiczna online
Sprawdz >>> http://link.interia.pl/f1dff

