Return-Path: <linux-kernel-owner+w=401wt.eu-S1759265AbXGEIns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265AbXGEIns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 04:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757574AbXGEInk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 04:43:40 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:21628 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757401AbXGEInj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 04:43:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=FmKIwKXahyWKmQ4Vwr8qkPUTr09MoX45nbphk6EA8IhCn3X4DMHF+kqmEBEWbZe9w1oJza9D3DsaFK1UYHS7ktn1NazDqHdMhK1t9I7yWOhuz+DIrGprQ0OwMWNnT/LLGJ04+FOvQJTDZ+dZMOq9G0fJv1scgnjl4a/rf9+TRzI=
Message-ID: <547a31ab0707050143n3d3df4b5k7c0135c3063fff3e@mail.gmail.com>
Date: Thu, 5 Jul 2007 10:43:37 +0200
From: Croulder <croulder@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Denial of Service in all kernels 2.6.x
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linux has the same problem that other OS:
"Multiple Vendor TCP Timestamp PAWS Remote Denial Of Service
Vulnerability"  published in 2005 by Noritoshi Demizu

If i send a SYN packet with high timestamp legitime user can not
establish a connection with the victim server.

Kernel Tested : 2.6.21.5 , 2.6.11.12

http://www.securityfocus.com/bid/13676/info

Temporal solution: echo "0" > /proc/sys/net/ipv4/tcp_timestamp

Final solution: ???
