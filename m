Return-Path: <linux-kernel-owner+w=401wt.eu-S1760473AbYHIDn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760473AbYHIDn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 23:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753766AbYHIDnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 23:43:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60508 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbYHIDnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 23:43:20 -0400
Message-ID: <489D1257.1040204@zytor.com>
Date: Fri, 08 Aug 2008 20:43:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christian Franke <cfchris6@yahoo.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc2] block: loop device partition support
References: <489CEADE.4030905@yahoo.de>
In-Reply-To: <489CEADE.4030905@yahoo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Franke wrote:
> From: Christian Franke <cfchris6@yahoo.de>
> 
> By default, partition support of loop devices is disabled and there 
> seems to be no way to turn it on without changing code, if loop is not 
> compiled as module.
> This patch introduces CONFIG_BLK_DEV_LOOP_MAXPART to make partition 
> support configurable via Kconfig. It keeps that feature disabled by 
> default for not breaking backward compatibility.

The right thing would be to have a backwards compatiblity major and a 
new major; similar to how the md device handles it.

	-hpa
