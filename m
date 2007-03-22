Return-Path: <linux-kernel-owner+w=401wt.eu-S934142AbXCVRS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934142AbXCVRS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 13:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934144AbXCVRS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 13:18:59 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:22765 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934142AbXCVRS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 13:18:58 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] ibmebus: change probe/remove interface from using loc-code to DT path
Date: Thu, 22 Mar 2007 18:15:50 +0100
User-Agent: KMail/1.6.2
Cc: linux-kernel@vger.kernel.org, pmac@au1.ibm.com, hnguyen@de.ibm.com,
       johnrose@austin.ibm.com, johnrose@us.ibm.com, nfont@austin.ibm.com,
       paulus@samba.org, themann@de.ibm.com
References: <200703221700.46292.fenkes@de.ibm.com>
In-Reply-To: <200703221700.46292.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200703221815.50506.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 March 2007 17:00, Joachim Fenkes wrote:
> Example:
> 
>  Add a device "/proc/device-tree/foo@12345678" to ibmebus like this:
>     echo /foo@12345678 > /sys/bus/ibmebus/probe
> 
>  Remove the device like this:
>     echo /foo@12345678 > /sys/bus/ibmebus/remove
> 

Of course, we have tested this on our own machines, including error
paths, and it worked fine.

Cheers,
  Joachim

---
Joachim Fenkes  --  eHCA Linux Driver Developer and Hardware Tamer
IBM Deutschland Entwicklung GmbH  --  Dept. 3627 (I/O Firmware Dev. 2)
Schoenaicher Strasse 220  --  71032 Boeblingen  --  Germany
eMail: fenkes@de.ibm.com  --  Phone: +49 7031 16 1239

