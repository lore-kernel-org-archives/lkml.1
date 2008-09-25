Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbYIYJ5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbYIYJ5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 05:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbYIYJ44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 05:56:56 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:47767 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbYIYJ44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 05:56:56 -0400
From: David Sanders <linux@sandersweb.net>
Reply-To: linux@sandersweb.net
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] VMware guest detection for x86 and x86-64
Date: Thu, 25 Sep 2008 05:56:48 -0400
User-Agent: KMail/1.9.5
Cc: Yan Li <elliot.li.tech@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
References: <48D12490.5010003@zytor.com> <48DA6887.1060709@zytor.com> <20080925003220.GE21049@yantp.cn.ibm.com>
In-Reply-To: <20080925003220.GE21049@yantp.cn.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809250556.49887.linux@sandersweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 September 2008 20:32, Yan Li wrote:
> If you can tell me what manufacture vendor string is in Virtual PC I
> can make another similar patch using dmi_name_in_vendors().
From: i8042-x86ia64io.h

	{
		.ident = "Microsoft Virtual Machine",
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
			DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
			DMI_MATCH(DMI_PRODUCT_VERSION, "VS2005R2"),
		},
	},
