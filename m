Return-Path: <linux-kernel-owner+w=401wt.eu-S1757697AbYDWOs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697AbYDWOs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 10:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbYDWOsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 10:48:04 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58245 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459AbYDWOsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 10:48:03 -0400
In-Reply-To: <eb3ff54b0804230434m5a844cf9w4b2ee074bce832c0@mail.gmail.com>
To: "Rami Rosen" <ramirose@gmail.com>
Cc: "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netdev-owner@vger.kernel.org,
       yoshfuji@linux-ipv6.org
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] [IPV6] Remove unused macro (MLDV2_QQIC) from mcast.c.
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF78FBCDB5.F62220EB-ON88257434.00508BE6-88257434.005148DA@us.ibm.com>
From: David Stevens <dlstevens@us.ibm.com>
Date: Wed, 23 Apr 2008 07:47:52 -0700
X-MIMETrack: Serialize by Router on D03NM121/03/M/IBM(Release 7.0.2FP2HF300 | September
 14, 2007) at 04/23/2008 08:47:55,
	Serialize complete at 04/23/2008 08:47:55
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The QQIC field is only used by multicast routers.

I don't object strongly to removing it, but it doesn't really save much
and it's potentially useful for debug printing or simply documenting how
to decode the field. So, I would leave it, but I agree it isn't a 
requirement
if Yoshifuji or Dave thinks it's better to remove it.

                                                +-DLS

