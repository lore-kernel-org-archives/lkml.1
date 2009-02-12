Return-Path: <linux-kernel-owner+w=401wt.eu-S1760172AbZBLVOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172AbZBLVOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 16:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbZBLVO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 16:14:28 -0500
Received: from smtprelay04.ispgateway.de ([80.67.18.16]:48734 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbZBLVO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 16:14:28 -0500
References: <cone.1234471033.988571.5384.1000@mentalhome> <20090212210330.GH12846@charite.de>
Message-ID: <cone.1234473266.28534.5384.1000@mentalhome>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Acer Aspire One fan control
Date: Thu, 12 Feb 2009 22:14:26 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Hildebrandt writes:

> There's a userspace program for that. So why add a kernel module?

Because you must write to and read from io-ports and I think this should be 
done in the kernel. I guess the userspace program you are talking about is 
acer_ec.pl? A perl script which needs very much cpu time for a 
functionality which can be handled in kernelspace without causing any big 
troubles.
