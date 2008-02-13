Return-Path: <linux-kernel-owner+w=401wt.eu-S932848AbYBMJ1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848AbYBMJ1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932621AbYBMJZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:25:43 -0500
Received: from smtp101.biz.mail.re2.yahoo.com ([68.142.229.215]:29775 "HELO
	smtp101.biz.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754660AbYBMJZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:25:39 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2008 04:25:39 EST
X-YMail-OSG: IBt7tfQVM1kEYyG2.HEC9kkDcq8BqBHIncAHx3dVgjyJvQ_plW77BJlJlyOj7d6CYyBehHLlJ3oV1lLjmco65J.ovy_Yd8.kArLni2mak182mJxCYfkTUYl4B9lFCAwdelRt9SQlYkEfPw--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <015c01c86e21$75317210$05c8a8c0@DIEGO>
From: "Diego Guella" <diego.guella@sircomtech.com>
To: "Steve Wise" <swise@opengridcomputing.com>,
       "Roland Dreier" <rdreier@cisco.com>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <general@lists.openfabrics.org>
References: <20080212220929.24442.76874.stgit@dell3.ogc.int> <adafxvxvgz3.fsf@cisco.com>
Subject: Re: [ofa-general] [PATCH 2.6.25] RDMA/cxgb3: Fail loopbackconnections.
Date: Wed, 13 Feb 2008 10:18:53 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One question below


----- Original Message ----- 
From: "Roland Dreier" <rdreier@cisco.com>
To: "Steve Wise" <swise@opengridcomputing.com>
Cc: <netdev@vger.kernel.org>; <linux-kernel@vger.kernel.org>; <general@lists.openfabrics.org>
Sent: Wednesday, February 13, 2008 1:26 AM
Subject: Re: [ofa-general] [PATCH 2.6.25] RDMA/cxgb3: Fail loopbackconnections.


> applied, although:
> 
> > +static void is_loopback_dst(struct iw_cm_id *cm_id)
> > +{
> > + struct net_device *dev;
> > + 
> > + dev = ip_dev_find(&init_net, cm_id->remote_addr.sin_addr.s_addr);
> > + if (!dev)
> > + return 0;

how can a static void function return 0?
%)

> > + dev_put(dev);
> > + return 1;

same here


