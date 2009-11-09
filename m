Return-Path: <linux-kernel-owner+w=401wt.eu-S1755113AbZKIJmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbZKIJmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbZKIJmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:42:51 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:47487 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754593AbZKIJmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:42:50 -0500
X-Sasl-enc: Ik8LTt0IXqavtfgRHwmq9D2KrOXSakQX/SrRwpc+fZzR 1257759726
Date: Mon, 9 Nov 2009 07:42:03 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Daniel Pittman <daniel@rimspace.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm@lists.linux-foundation.org,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Massive ext4 filesystem corruption after a failed
 s2disk/ram cycle
Message-ID: <20091109094203.GA10007@khazad-dum.debian.net>
References: <87vdisq7bh.fsf@rimspace.net>
 <20091007161604.GA28849@infradead.org>
 <20091104111125.54C3.A69D9226@jp.fujitsu.com>
 <20091108082905.GA25494@discord.disaster>
 <20091108164913.GA12053@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108164913.GA12053@infradead.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Nov 2009, Christoph Hellwig wrote:
> IMHO the best option is to have a separate partition for /boot with a
> very simple filesystem that we can expect boot loader developers to
> implement fully and correctly.

Agreed.  And one that is not all but abandoned kernel-side, or you will risk
bugs there.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
