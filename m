Return-Path: <linux-kernel-owner+w=401wt.eu-S1759612AbXEKIlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612AbXEKIlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 04:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbXEKIks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 04:40:48 -0400
Received: from mail.sjtu.org ([202.120.5.34]:21811 "ehlo appsrv1.sjtu.org"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754888AbXEKIkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 04:40:46 -0400
Subject: Re: [PATCH] v4l: saa7134: support ir-remote for 10moons TM300
From: Tony Wan <wankai@sjtu.org>
To: "Nickolay V. Shmyrev" <nshmyrev@yandex.ru>
Cc: mchehab@infradead.org, michael@mihu.de, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <1178869883.7163.2.camel@gnome.local>
References: <1178852562.7216.4.camel@wankai.sjtu.org>
	 <1178869883.7163.2.camel@gnome.local>
Content-Type: text/plain
Date: Fri, 11 May 2007 16:38:43 +0800
Message-Id: <1178872723.5020.7.camel@wankai.sjtu.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-11 at 11:51 +0400, Nickolay V. Shmyrev wrote:
> Great, now another correction, sorry for not noticing it before. With
> correction of bit 0x4 -> 0x2 your remote is exactly the same as 
> ir_codes_encore_enltv so probably there is sense just to reuse old
> codes. Elencore mask should be reduced too. I also wonder aren't we
> talking about the same card here.
> 
> 

It's interesting. I checked the source code, but I don't think that
Elencore and TM300 is the same card. In fact, they have different tuner
modules. Or they use the same ir-remote?

