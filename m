Return-Path: <linux-kernel-owner+w=401wt.eu-S1759023AbXKFT6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759023AbXKFT6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756807AbXKFTwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:52:31 -0500
Received: from 1wt.eu ([62.212.114.60]:3731 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132AbXKFTwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:52:04 -0500
Date: Tue, 6 Nov 2007 20:51:48 +0100
From: Willy Tarreau <w@1wt.eu>
To: Romano Giannetti <romanol@upcomillas.es>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc1 eat my photo SD card :-(
Message-ID: <20071106195148.GD1045@1wt.eu>
References: <1193918202.8439.7.camel@rukbat> <20071102182833.2c055446@poseidon.drzeus.cx> <1194168583.10245.15.camel@rukbat> <ada8x5ec7oh.fsf@cisco.com> <1194259886.6927.9.camel@localhost> <20071105132218.495f244e@poseidon.drzeus.cx> <1194270393.27789.2.camel@localhost> <20071105162633.09e54290@poseidon.drzeus.cx> <1194343121.6953.6.camel@rukbat>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194343121.6953.6.camel@rukbat>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 10:58:41AM +0100, Romano Giannetti wrote:
(first time)
> 0000000 0000 0000 31e4 c363 d908 cb2e 0000 0000

(fourth time)
> 0000000 0000 0000 71e4 c36f d908 cb2e 0000 0000

(fifth time)
> 0000000 0000 0000 f1e4 c37b d908 cb2e 0000 0000

Most always, you have only a few bits which change, and always for
the same bytes :

  31 -> 71 -> f1  (|40, |80)
  63 -> 6f -> 7b  (|0c, |10&~4)

It looks like a hardware problem to me. Maybe one version is more
optimized and puts more stress on the device ? I remember having
had comparable problems in the past with a CF connected to a
home-made IDE adapter on which the +5V wire had been cut. The CF
drained its power from the IDE signals and it would most always
work correctly, except when reading large files. Writing to it
finally killed it.  

Regards,
Willy

