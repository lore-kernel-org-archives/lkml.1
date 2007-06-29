Return-Path: <linux-kernel-owner+w=401wt.eu-S933551AbXF2Pyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551AbXF2Pyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 11:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758920AbXF2Pye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 11:54:34 -0400
Received: from www.vanteon.com ([64.129.125.130]:4036 "EHLO RDC03.vanteon.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757475AbXF2Pyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 11:54:33 -0400
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jun 2007 11:54:33 EDT
Message-ID: <468527A2.40909@vanteon.com>
Date: Fri, 29 Jun 2007 11:39:14 -0400
From: Greg Huber <ghuber@vanteon.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Assistance debugging a Micrel network driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I hope this is the right place to request some assistance, my apologizes 
if its not.

I'm currently developing a network driver for a new controller chip. The 
driver is mostly complete and appears to be working,
with the exception that messages received and sent up the stack appear 
to get dropped by a higher layer. Specifically we
are seeing ARP "who is" requests go out, and the response come back 
(only 2 nodes on this network), the skb is configured
and the frame is sent up with netif_rx (we haven't started supporting 
NAPI yet). The response seems to get dropped somewhere
as another ARP "who is" request is sent. I am using the 2.6.21.5 kernel 
(compilied with network debugging turned on) and we
have also tested with the 2.6.17 kernel, all acted the same.

The upper layers obviously work so I'm sure it's something in my driver.

I have turned on as much debugging in the kernel as I could find, but I 
get no messages. Could someone please let me know if
there is additional debugging I should consider or if there is a dynamic 
way to turn on debugging in L2 and/or L3.

Additionally, if anyone has any idea what might be happening, I would 
greatly appreciate any information.

Thank You

Greg

-- 

Greg Huber
Principal Engineer
Vanteon Corporation
255 Woodcliff Drive, Suite 200
Fairport, NY 14450
Office: (585) 419-9564
Fax: (585) 248-0537
www.vanteon.com <http://www.vanteon.com>  - Embedded for Your Future

