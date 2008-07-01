Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbYGAQ1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbYGAQ1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 12:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbYGAQ1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 12:27:35 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:3553 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbYGAQ1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 12:27:34 -0400
X-IronPort-AV: E=Sophos;i="4.27,732,1204502400"; 
   d="scan'208";a="837787"
Message-ID: <486A5B1A.6050901@eu.citrix.com>
Date: Tue, 01 Jul 2008 17:28:10 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1 of 2] fbcon: bgcolor fix
References: <486A4F64.3050904@eu.citrix.com> <alpine.LNX.1.10.0807011750570.20393@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0807011750570.20393@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jul 2008 16:27:33.0477 (UTC) FILETIME=[5D785150:01C8DB97]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:

> On Tuesday 2008-07-01 17:38, Stefano Stabellini wrote:
> 
>> The forth bit of the background color is the blink property bit, not the
>> intensity bit, as for the foreground color.
>> Therefore it shouldn't be included in the background color.
> 
> I'm a bit skeptical, though I have not tried this.


If you look at the build_attr function in drivers/char/vt.c you can see 
that the blink attribute is stored as the forth bit of the background color.

I tried the patches with both an ncurses application and manually using:

echo -en '\E[5m'

and they seems to work fine.
