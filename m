Return-Path: <linux-kernel-owner+w=401wt.eu-S1752195AbXLEBMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbXLEBMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 20:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbXLEBLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 20:11:54 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:23766 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbXLEBLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 20:11:54 -0500
Date: Tue, 04 Dec 2007 19:11:37 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: solid state drive access and context switching
In-reply-to: <fa.4uUCLsuQFjc4FtQYCBYK6kY9TiU@ifi.uio.no>
To: Chris Friesen <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <4755FAC9.5050901@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.4uUCLsuQFjc4FtQYCBYK6kY9TiU@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> 
> Over on comp.os.linux.development.system someone asked an interesting 
> question, and I thought I'd mention it here.
> 
> Given a fast low-latency solid state drive, would it ever be beneficial 
> to simply wait in the kernel for synchronous read/write calls to 
> complete?  The idea is that you could avoid at least two task context 
> switches, and if the data access can be completed at less cost than 
> those context switches it could be an overall win.
> 
> Has anyone played with this concept?

I don't think most SSDs are fast enough that it would really be worth 
avoiding the context switch for.. I could be wrong though.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

