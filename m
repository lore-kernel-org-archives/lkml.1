Return-Path: <linux-kernel-owner+w=401wt.eu-S1761960AbZFRLsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761960AbZFRLsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 07:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760749AbZFRLsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 07:48:46 -0400
Received: from mail.windriver.com ([147.11.1.11]:37388 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759615AbZFRLsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 07:48:46 -0400
Message-ID: <4A3A299A.9090607@windriver.com>
Date: Thu, 18 Jun 2009 06:48:42 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] usb-serial: regression fix to move sysrq from hot
 path
References: <1245291609-14871-1-git-send-email-jason.wessel@windriver.com><1245291609-14871-2-git-send-email-jason.wessel@windriver.com><1245291609-14871-3-git-send-email-jason.wessel@windriver.com> <20090618101320.15c036a6@lxorguk.ukuu.org.uk>
In-Reply-To: <20090618101320.15c036a6@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jun 2009 11:48:37.0717 (UTC) FILETIME=[B7960050:01C9F00A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> +	if (port->console) {
>>     
>
> 	unlikely(port->console) I think is justified
>
>   

I pushed that change into my for_linus git branch.

That just leaves patch 3 in the series for Greg KH.

Thanks,
Jason.
