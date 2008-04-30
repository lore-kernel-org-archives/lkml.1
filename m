Return-Path: <linux-kernel-owner+w=401wt.eu-S1759988AbYD3RQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988AbYD3RQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 13:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757437AbYD3RPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 13:15:51 -0400
Received: from n1a.bullet.mail.kr1.yahoo.com ([203.212.170.72]:33071 "HELO
	n1a.bullet.mail.kr1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757401AbYD3RPv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 13:15:51 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Apr 2008 13:15:50 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 174253.11598.bm@omp103.mail.in2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=nLnLRwXw3D8ttaL8sKEwjR1ZyVToWdNv53RSXlEV1rRam2tly9koXNtWfLvtoShXgyHmDMtConDYd3GCeOq+42GbHg8ZEIP8LZQUModlRxDYIKeVYgY1uOgh2rz2LoocIKvRqJtGxnS5l86Di3qKv1WIbG7RPKY8qmqYfvkqTMY=;
X-YMail-OSG: heW7duEVM1maSoY.GroFiqjrcZjDv3LvV0LKrk7tJWMSnu1AENfVpGUo19F3aC6MAJ55VqEcD_QelOXJGWGqbDfVU8Jak6fWWg--
X-Mailer: YahooMailRC/902.40 YahooMailWebService/0.7.185
Date: Wed, 30 Apr 2008 22:39:14 +0530 (IST)
From: Soumyadip Das Mahapatra <dip_kernel@yahoo.co.in>
Subject: Improved Swapping Method In sort.c
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <988568.21908.qm@web94102.mail.in2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,
The swapping method (in function void u32_swap() line no.. 14 to 16) in lib/sort.c can be improved by using the following code
*(u32 *)b ^= *(u32 *)a ^= *(u32 *)b ^= *(u32 *)a instead of the code given. This code
is not using third variable thus not consuming another memory. And I dont see any significance in
using *int size* argument. so the function should be
static void u32_swap(void *a, void *b)
{
    *(u32 *)b ^= *(u32 *)a ^= *(u32 *)b ^= *(u32 *)a;
}




      Meet people who discuss and share your passions. Go to http://in.promos.yahoo.com/groups/bestofyahoo/

