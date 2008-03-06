Return-Path: <linux-kernel-owner+w=401wt.eu-S934284AbYCFVvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934284AbYCFVvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764172AbYCFVuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:50:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58707 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763678AbYCFVui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:50:38 -0500
Message-ID: <47D065DB.7070708@zytor.com>
Date: Thu, 06 Mar 2008 13:44:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Roel Kluin <12o3l@tiscali.nl>
CC: elf@buici.com, Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] locomo.c: convert strncpy(x, y, sizeof(x)) to strlcpy
References: <47CFECCB.7050909@tiscali.nl>
In-Reply-To: <47CFECCB.7050909@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> This patch was not yet tested. Please confirm it's right.
> ---
> strncpy does not append '\0' if the length of the source string equals
> the size parameter, strlcpy does.
> 

Are you sure it's safe to not zero out the contents of the buffer (no 
information leak)?

	-hpa
