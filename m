Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbYDUBKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbYDUBKj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 21:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbYDUBKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 21:10:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:4395 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbYDUBK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 21:10:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=hhoYe90O56BbSOqun43rZm2lLfyJ1MV7pPdIZrR2obNEXiycVkCW4BgzVle69TEsMOpAwxYm7f2zNz/fVdoXBjWCNMDlys+3gir35ufKrUI+jBtdYBi1v3wcy2InQejHlWScIzLtGpUAdVUvIMoQwyyCamaUvqIxm1/SqkDPmzg=
Message-ID: <480BE97D.9020402@gmail.com>
Date: Mon, 21 Apr 2008 03:10:21 +0200
From: =?ISO-8859-1?Q?Enrique_G=F3mez?= <egomezm@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: About IP options in UDP
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, I am trying to find the place of the kernel, in which calculates 
the size of the IP Packets, taking into account the IP options that the 
packet could have.

I have found the answer of this question in *TCP*. In the file 
net/ipv4/tcp_output.c there is a function called "tcp_mtu_to_mss" where 
calculates the PMTU, taking into account IP options.

Now, I would like to know where *UDP* does this operation.

I would be very glad of receiving any answer.

Thanks.

Enrique.
