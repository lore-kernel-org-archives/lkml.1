Return-Path: <linux-kernel-owner+w=401wt.eu-S1757883AbYFEM1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbYFEM1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 08:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757105AbYFEM0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 08:26:52 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53780 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757024AbYFEM0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 08:26:51 -0400
X-Sasl-enc: 4Q0BAsVkMs6aw5zUc/I1s4w3xmF5O0zAx63ay5VZzuPb 1212668810
Message-ID: <4847DB82.60408@ladisch.de>
Date: Thu, 05 Jun 2008 14:26:42 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/18] ihex.h: binary representation of ihex records
References: <20080605.foo@pmac.infradead.org> <E1K4C9q-0001dA-5i@bombadil.infradead.org>
In-Reply-To: <E1K4C9q-0001dA-5i@bombadil.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> Some devices need their firmware as a set of {address, len, data...}
> records in some specific order rather than a simple blob.

At least in the case of EZ-USB-based devices, this is not a requirement.
It seems most tools just do not bother to order the records in Intel hex
files.  Any firmware that is downloaded with the EZ-USB's "load
internal" request (0xa0) can be converted to a plain memory dump.


Regards,
Clemens
