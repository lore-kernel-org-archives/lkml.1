Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab0CEJQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 04:16:26 -0500
Received: from lilzmailso01.liwest.at ([212.33.55.23]:8709 "EHLO
	lilzmailso02.liwest.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751505Ab0CEJQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 04:16:24 -0500
X-Greylist: delayed 624 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Mar 2010 04:16:24 EST
Message-ID: <4B90CBE5.9090102@viscovery.net>
Date: Fri, 05 Mar 2010 10:16:21 +0100
From: Johannes Sixt <j.sixt@viscovery.net>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: git@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: gitignore broken in git 1.7.0.1: slash checks leading dirs
References: <4B90C701.3070308@gmail.com> <4B90C974.2050405@viscovery.net> <4B90C9BE.1030407@gmail.com>
In-Reply-To: <4B90C9BE.1030407@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby schrieb:
> On 03/05/2010 10:05 AM, Johannes Sixt wrote:
>> Jiri Slaby schrieb:
>>> ***
>>> If the pattern does not contain a slash /, git treats it as a shell
>>> glob pattern and checks for a match against the pathname without
>>> leading directories.
>>> ***
>> and this citation confirms my expectation. Note that it says "pathname",
>> not "filename". 'include/linux' is a "pathname".
> 
> What are 'leading directories' then?

'include/' is the leading directory of 'include/linux'.

The cited sentence says that the particular check considers only the last
path component of the pathname.

-- Hannes

