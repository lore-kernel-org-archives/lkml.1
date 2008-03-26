Return-Path: <linux-kernel-owner+w=401wt.eu-S1758871AbYCZPtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871AbYCZPtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbYCZPt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:49:27 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:50661 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbYCZPt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:49:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=dMX/f5p+CfWUw0LdOk2MZLNDQ0DD3wIa1xoAasaXpD71mKA4hkOrBepDQ+epInpIao3xSTGvpMIszuBTQS9AzucOTw8cQgtr+xUubnFeJoDvyycEZa4plACU8OtUhF9LQ+yDYiLUPh2cbxPRt6JgzE439P0K/7JrDj+Tv1TOQRM=
Date: Wed, 26 Mar 2008 18:49:13 +0300
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, hskinnemoen@atmel.com, domen.puncer@telargo.com,
       lethal@linux-sh.org, tony@atomide.com, rmk+kernel@arm.linux.org.uk,
       paul@pwsan.com
Subject: [PATCH 0/3] Clocklib: generic clocks framework
Message-ID: <20080326154913.GA15326@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The <linux/clk.h> provides the API to use clocks.
However there is no API for clock providers. Commonly
clocks are provided by platform-specific code, which
implements full <linux/clk.h> API for itself. It results
in massive code duplication and lack of flexibility.
If I'd like to be able to provide clocks from the driver
for e.g. CPU companion chip, I'd either have to implement
a lot of platform-specific hooks, or invent some other
dirty hacks.

In the followup I'd like to propose the generic <linux/clk.h>
implementation, that can be used to hook clock definitions
from various sources. Also as an example there will be a patch
to convert ARM SA-1100 to the clocklib.

I'd like arch maintainers to check whether there is somthing
in this implementation that wouldn't work for their piece
of kernel, whether is's suitable for them to drop their own
clock implementation (if any) and to use clocklib.

-- 
With best wishes
Dmitry

