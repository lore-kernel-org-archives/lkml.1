Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbXCSJYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbXCSJYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 05:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbXCSJYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 05:24:36 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:54414 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753392AbXCSJY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 05:24:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=idnRoqzPMDbIPj+YeHaDOAB/kBzX9SiUmjw+A+hZkvToHXxO0LxM5xUDMeNNPpJ0Ip0whd2W3cqPnpwhL3/EtLtz9aL0ZcSV/65HRrh0lYdBadR9uyMClSc+wP62w05Fv2rN1IbWBQ6Vovjp0LmSiGK8DIW8czikzSxdQZGM9Pg=;
Date: Mon, 19 Mar 2007 12:24:22 +0300
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: "Eric W. Biederman" <ebiederman@lnxi.com>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: dst_ifdown breaks infiniband?
Message-ID: <20070319092422.GB9387@ms2.inr.ac.ru>
References: <20070318155532.GG7958@mellanox.co.il> <20070318191238.GA20518@ms2.inr.ac.ru> <20070318202559.GD11078@mellanox.co.il> <m3tzwi8a20.fsf@maxwell.lnxi.com> <20070318223653.GO11078@mellanox.co.il> <20070318224234.GP11078@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070318224234.GP11078@mellanox.co.il>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> Does this look sane (untested)?

It does not, unfortunately.

Instead of regular crash in infiniband you will get numerous
random NULL pointer dereferences both due to dst->neighbour
and due to dst->dev.

Alexey
