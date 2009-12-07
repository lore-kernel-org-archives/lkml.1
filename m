Return-Path: <linux-kernel-owner+w=401wt.eu-S935305AbZLGPUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935305AbZLGPUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935259AbZLGPUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:20:36 -0500
Received: from procserver.webwayone.co.uk ([62.8.115.202]:52710 "EHLO
	procserver.webwayone.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932683AbZLGPUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:20:36 -0500
DomainKey-Signature: a=rsa-sha1; s=procserver; d=webwayone.co.uk; c=nofws; q=dns;
	h=x-dkim:dkim-signature:x-batv:x-virus-status:
	x-virus-scanned:x-dkim:authentication-results:from:to:cc:subject:references:date:
	in-reply-to:message-id:user-agent:mime-version:content-type;
	b=QCNz5QB9kaAs2vKPrYDnxf7oz+bOMvrqD3dAEkb0FYo/61PSjsgowyscmJNPf/0/4
	dwDEXwJKq/FY8YdHo6iGw==
X-DKIM: OpenDKIM Filter v1.1.1.dev procserver.webwayone.co.uk nB7FKdhY018536
X-BATV: Sendmail BATV Filter v0.4.0 procserver nB7FKdhY018536
X-DKIM: OpenDKIM Filter v1.1.1.dev procserver.webwayone.co.uk nB7FKdhY018536
Authentication-Results: procserver.webwayone.co.uk; dkim=none
	(no signature) header.i=unknown; dkim-adsp=none
From: Graham Murray <gmurray@webwayone.co.uk>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.32 CONFIG_SX marked as BROKEN
References: <7wd42vyp2i.fsf@webwayone.co.uk> <20091204170252.GA2504@suse.de>
Date: Mon, 07 Dec 2009 15:20:39 +0000
In-Reply-To: <20091204170252.GA2504@suse.de> (Greg KH's message of "Fri, 4 Dec
	2009 09:02:52 -0800")
Message-ID: <7wzl5uajzs.fsf@webwayone.co.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (i686-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Fri, Dec 04, 2009 at 11:08:05AM +0000, Graham Murray wrote:
>> Commit 412145947adfca60a4b5b4893fbae82dffa25edd marked CONFIG_SX as
>> Broken. The commit comments state that there are no users. We are using
>> SX cards in production servers. I discovered this when I attempted to
>> upgrade a development server to 2.6.32 and it failed to find the cards.
>
> Do you have the ability to test patches to verify changes in order to
> help fix up this driver?

Yes, I have the ability to test patches. 
