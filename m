Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbZDMOqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbZDMOqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 10:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbZDMOqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 10:46:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43383 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbZDMOqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 10:46:30 -0400
Date: Mon, 13 Apr 2009 10:46:26 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Ryo Tsuruta <vivek.goyal2008@gmail.com>
Cc: agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: dm-ioband: Test results.
Message-ID: <20090413144626.GF18007@redhat.com>
References: <20090413.130552.226792299.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413.130552.226792299.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 01:05:52PM +0900, Ryo Tsuruta wrote:
> Hi Alasdair and all,
> 
> I did more tests on dm-ioband and I've posted the test items and
> results on my website. The results are very good.
> http://people.valinux.co.jp/~ryov/dm-ioband/test/test-items.xls
> 

Hi Ryo,

I quickly looked at the xls sheet. Most of the test cases seem to be
direct IO. Have you done testing with buffered writes/async writes and
been able to provide service differentiation between cgroups?

For example, two "dd" threads running in two cgroups doing writes.

Thanks
Vivek
