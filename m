Return-Path: <linux-kernel-owner+w=401wt.eu-S1758104AbZHQVFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104AbZHQVFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 17:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758091AbZHQVFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 17:05:07 -0400
Received: from senator.holtmann.net ([87.106.208.187]:53663 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758090AbZHQVFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 17:05:06 -0400
Subject: Re: Existing netlink kernel <--> kernel communication
From: Marcel Holtmann <marcel@holtmann.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kevin Hayes <kevin@atheros.com>,
       Jouni Malinen <j@w1.fi>, Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <43e72e890908171137v73732ea3g957e574eae3a81d8@mail.gmail.com>
References: <43e72e890908171137v73732ea3g957e574eae3a81d8@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 14:04:33 -0700
Message-Id: <1250543073.30166.100.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

> Was curious if there are existing use cases of netlink for kernel <-->
> kernel communication rather than the typical kernel <--> userspace.
> The original RFC 3549 [1] does specify it could have been used for
> "intra-kernel messaging", but am just not aware of existing use cases.
> A pointer could help.

I would use direct function calls for kernel to kernel communication. No
need to put any messaging system in between.

Regards

Marcel


