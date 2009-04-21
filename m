Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbZDUNyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbZDUNyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 09:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbZDUNyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 09:54:35 -0400
Received: from nox.protox.org ([88.191.38.29]:36395 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbZDUNyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 09:54:35 -0400
Subject: Re: ioremap_wc | set_memory_(uc|wc) and suspend
From: Jerome Glisse <glisse@freedesktop.org>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1240251490.3005.3.camel@earl.localdomain>
References: <1240251490.3005.3.camel@earl.localdomain>
Content-Type: text/plain
Date: Tue, 21 Apr 2009 15:54:31 +0200
Message-Id: <1240322071.2937.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-20 at 20:18 +0200, Jerome Glisse wrote:
> Hello,
> 
> Is this crazy|forbidden to do ioremap_wc or
> set_memory_(uc|wc) in a device driver suspend
> callback ? Right now on  AMD Athlon Dual Core
> any calls to this functions won't return (when
> called from suspend hook).
> 
> Cheers,
> Jerome Glisse

So it seems it was due to me accessing an unmapped
area (being the console buffer) which triggered the
bug, i was just unable to see message further down.

Sorry for the noise.

Cheers,
Jerome Glisse

