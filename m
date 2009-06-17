Return-Path: <linux-kernel-owner+w=401wt.eu-S933439AbZFQMlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439AbZFQMlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 08:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764744AbZFQMlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 08:41:07 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50642 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757717AbZFQMlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 08:41:05 -0400
Subject: Re: [PATCH 2/9] percpu: use dynamic percpu allocator as the
 default percpu allocator
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, kyle@mcmartin.ca, cl@linux-foundation.org,
       Jesper.Nilsson@axis.com, benh@kernel.crashing.org,
       paulmck@linux.vnet.ibm.com, Paul Mundt <lethal@linux-sh.org>,
       Russell King <rmk@arm.linux.org.uk>, Mikael Starvik <starvik@axis.com>,
       Ralf Baechle <ralf@linux-mips.org>, Bryan Wu <cooloney@kernel.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Parisc List <linux-parisc@vger.kernel.org>
In-Reply-To: <1245210060-24344-3-git-send-email-tj@kernel.org>
References: <1245210060-24344-1-git-send-email-tj@kernel.org>
	 <1245210060-24344-3-git-send-email-tj@kernel.org>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 08:40:59 -0400
Message-Id: <1245242459.4503.4.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 12:40 +0900, Tejun Heo wrote:
> 
> The following architectures are affected by this change.
> 
> * sh
> * arm
> * cris
> * mips
> * sparc(32)
> * blackfin
> * avr32
> * parisc (broken, under investigation)

I haven't seen anything of this on the parisc list ... what's the
problem?  and do you need systems or any other help to fix it?

James


