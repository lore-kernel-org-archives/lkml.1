Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbZHQSLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbZHQSLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 14:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbZHQSLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 14:11:23 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:32811 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbZHQSLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 14:11:23 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A899D41.7000405@s5r6.in-berlin.de>
Date: Mon, 17 Aug 2009 20:11:13 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090630 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ohci1396_dma=early nogo on an imac?
References: <4A88F6BF.7090104@gmail.com> <4A89722A.1070407@s5r6.in-berlin.de> <dd18b0c30908171104o7ed67aa3x7cab741263de09c3@mail.gmail.com>
In-Reply-To: <dd18b0c30908171104o7ed67aa3x7cab741263de09c3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Mattock wrote:
> [  660.190134] ieee1394: Current remote IRM is not 1394a-2000
> compliant, resetting...
...
> keeps going.

It's a bug in ieee1394.  http://bugzilla.kernel.org/show_bug.cgi?id=8403

Use the ieee1394 disable_irm=1 parameter on one or both nodes.  Perhaps 
firescope will then get going as well.
-- 
Stefan Richter
-=====-==--= =--- =---=
http://arcgraph.de/sr/
