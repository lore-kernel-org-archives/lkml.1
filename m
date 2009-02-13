Return-Path: <linux-kernel-owner+w=401wt.eu-S1757139AbZBMJQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbZBMJQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 04:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbZBMJQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 04:16:28 -0500
Received: from web15704.mail.cnb.yahoo.com ([202.165.102.71]:34402 "HELO
	web15704.mail.cnb.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750889AbZBMJQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 04:16:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.cn;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=QgsErVyT2G7hqrLjwY5MXYMksMuEGTPW1jSGIO6zV1BNu7JgR+dVNoT4E6QCqw6vnLMwhaUlQX8wGiJ8iRCix09ibXgHT9PV+NQGmkE+eTJoWYfBJYuoajy7QWh26NPWzaoUFkd+aNjy88MvSfsAAme2Ek1qMhfo1GBkjrl2ADA=;
X-YMail-OSG: rQYTOYoVM1mevSJf5l8lRDlTxidpJQ693_6yOjexvo4QWJJBWiyQJKwh4HDyeWKHjvmU6rM29A_M8U5IKt4KsqaQFCpHEF0j8LRlwL4TDVEHroKnpXZzB2fDVRNpvkX.bwrzuGI.DrWhsu_rRSezKgI0zNfKFa31u.Gsaq9qHdyPNXlapx2ydSPr7_MQCffR1Y5TqSMIijYgmpZ92IODqOCXKVs-
X-Mailer: YahooMailWebService/0.7.260.1
Date: Fri, 13 Feb 2009 17:16:24 +0800 (CST)
From: peter meng <mengsanshui@yahoo.com.cn>
Reply-To: mengsanshui@yahoo.com.cn
Subject: Question about s3c24xx_dma_addr in kernel ?
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <761645.35452.qm@web15704.mail.cnb.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


HI

I found never used both the from and to field of s3c24xx_dma_addr in Linux except declare s3c24XX_dma_mappings .

So I want to know why still leave this struct in kernel ? 


Thanks a lot .
Best Regards.
Peter Meng 


struct s3c24xx_dma_addr {
	unsigned long		from;
	unsigned long		to;
};

struct s3c24xx_dma_map {
	const char		*name;
	struct s3c24xx_dma_addr  hw_addr;

	unsigned long		 channels[S3C2410_DMA_CHANNELS];
	unsigned long		 channels_rx[S3C2410_DMA_CHANNELS];
};

static struct s3c24xx_dma_map __initdata s3c2412_dma_mappings[] = {
	[DMACH_XD0] = {
		.name		= "xdreq0",
		.channels	= MAP(S3C2412_DMAREQSEL_XDREQ0),
		.channels_rx	= MAP(S3C2412_DMAREQSEL_XDREQ0),
	},
	[DMACH_XD1] = {
		.name		= "xdreq1",
		.channels	= MAP(S3C2412_DMAREQSEL_XDREQ1),
		.channels_rx	= MAP(S3C2412_DMAREQSEL_XDREQ1),
	},
	[DMACH_SDI] = {
		.name		= "sdi",
		.channels	= MAP(S3C2412_DMAREQSEL_SDI),
		.channels_rx	= MAP(S3C2412_DMAREQSEL_SDI),
		.hw_addr.to	= S3C2410_PA_SDI + S3C2410_SDIDATA,
		.hw_addr.from	= S3C2410_PA_SDI + S3C2410_SDIDATA,
        ..........




      
