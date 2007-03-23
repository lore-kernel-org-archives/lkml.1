Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbXCWU1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbXCWU1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 16:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbXCWU1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 16:27:49 -0400
Received: from mail.emacinc.com ([63.245.244.68]:33913 "EHLO mail.emacinc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415AbXCWU1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 16:27:48 -0400
From: NZG <ngustavson@emacinc.com>
Organization: EMAC.Inc
To: linux-kernel@vger.kernel.org
Date: Fri, 23 Mar 2007 15:28:10 -0500
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200703231528.10508.ngustavson@emacinc.com>
X-SA-Exim-Connect-IP: 63.245.244.67
X-SA-Exim-Mail-From: ngustavson@emacinc.com
Subject: default functions for gpio
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Relay: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

WHY I"M ASKING THIS QUESTION:
I'm implementing some gpio calls in the ep93xx arch.
My problem is that gpio's are really board specific, not just mach specific.
I can code the function calls into my board init, but where should these 
functions be prototyped?

Ideally, I think the compiler should build a "default" function for 
int gpio_request which fails, rather than a compile error for other boards 
within the same arch.


THE ACTUAL QUESTION:
Is there a way to build a "default" function, which is compiled in if it's not 
defined elsewhere? Anyone know where an example of this might be lurking.
Also, if this is possible, is it a good idea?

thx,
NZG

