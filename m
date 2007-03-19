Return-Path: <linux-kernel-owner+w=401wt.eu-S1752642AbXCSJU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbXCSJU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 05:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbXCSJU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 05:20:26 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:54253 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752423AbXCSJUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 05:20:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=j57md+G99+Bj5dZ/zvy/PmS95Qo8D52OEczeic4cdtXQmJp8ZOLXMJZ4IxvmNrOPGtc2grbD5Zk/iCLfuWKqVgQQqb/w54Sgqj6rGVE9EczQg/a00ZaN1chOTa6H9BBQN9kdK6R44psd49hpQcQGpLf5MrdQSHvskqApxtPgh1w=;
Date: Mon, 19 Mar 2007 12:20:09 +0300
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: "Eric W. Biederman" <ebiederman@lnxi.com>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: dst_ifdown breaks infiniband?
Message-ID: <20070319092009.GA9387@ms2.inr.ac.ru>
References: <20070318155532.GG7958@mellanox.co.il> <20070318191238.GA20518@ms2.inr.ac.ru> <20070318202559.GD11078@mellanox.co.il> <m3tzwi8a20.fsf@maxwell.lnxi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3tzwi8a20.fsf@maxwell.lnxi.com>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> Well I don't think the loopback device is currently but as soon
> as we get network namespace support we will have multiple loopback
> devices and they will get unregistered when we remove the network
> namespace.

There is no logical difference. At the moment when namespace is gone
there is nobody who can hold unrevokable references to this loopback.

Alexey
