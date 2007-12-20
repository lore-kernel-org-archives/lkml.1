Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbXLTSoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbXLTSoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 13:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbXLTSoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 13:44:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58208 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbXLTSoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 13:44:04 -0500
Message-ID: <476AB640.4040005@zytor.com>
Date: Thu, 20 Dec 2007 10:36:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: [RFC] [PATCH 1/3] Merge mkimage tool for building uImages
References: <20071220101643.48b427ef@zod.rchland.ibm.com> <20071220101739.45b28d26@zod.rchland.ibm.com>
In-Reply-To: <20071220101739.45b28d26@zod.rchland.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer wrote:
> Several platforms require the mkimage tool to generate a uImage file
> that is used with U-Boot.  This brings the mkimage tool in-kernel to
> enable building those platforms without having mkimage internally
> provided.
> 
> This is currently based off of the version found in U-Boot 1.3.1.
> 

Can we rename it either "ubootimage" or "mkuboot" or something else that 
tells the user what kind of image it is?  (It is, in particular, not 
bzImage, which is probably the first thing that someone who sees "image" 
in a arch-generic part of the Linux kernel tree will think.)

	-hpa
