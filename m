Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbYK2E6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbYK2E6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 23:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbYK2E6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 23:58:13 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:19773 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbYK2E6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 23:58:12 -0500
Message-ID: <4930CBB7.6000203@oracle.com>
Date: Fri, 28 Nov 2008 20:57:27 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2008-11-26-17-00 uploaded (backlight)
References: <200811270101.mAR114rp016378@imap1.linux-foundation.org>
In-Reply-To: <200811270101.mAR114rp016378@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4930CBBA.00EF:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2008-11-26-17-00 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> It contains the following patches against 2.6.28-rc6:

mmotm-2008-1126-1700/drivers/video/backlight/backlight.c:95: warning: format '%d' expects type 'int', but argument 2 has type 'long unsigned int'

caused by (almost duplicated/fixed lines):


		pr_debug("backlight: set power to %lu\n", power);
		pr_debug("backlight: set power to %d\n", power);

Someone please delete the second line.


-- 
~Randy
