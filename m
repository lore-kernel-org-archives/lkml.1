Return-Path: <linux-kernel-owner+w=401wt.eu-S1030280AbXBZOZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030280AbXBZOZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 09:25:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030281AbXBZOZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 09:25:19 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:58302 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030280AbXBZOZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 09:25:17 -0500
Date: Mon, 26 Feb 2007 08:25:15 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: list.h , list_head and C++
In-reply-to: <1172493644.311389.243780@8g2000cwh.googlegroups.com>
To: "remi.chateauneu@gmail.com" <remi.chateauneu@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <45E2EDCB.8070008@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <1172493644.311389.243780@8g2000cwh.googlegroups.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

remi.chateauneu@gmail.com wrote:
> My C++ program needs an intrusive list, possibly with RCU
> capabilities.The data structure list_head, defined in /usr/include/
> linux/list.h , fits perfectly these needs.

You really shouldn't use kernel data structures in userspace. The 
locking and other primitives they depend on are not guaranteed to work. 
Also keep in mind that using these structures probably makes your 
program a derivative of the kernel and would require your software to be 
released under the GPL.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

