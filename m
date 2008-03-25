Return-Path: <linux-kernel-owner+w=401wt.eu-S1757750AbYCYQAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750AbYCYQAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757213AbYCYQAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:00:03 -0400
Received: from mx06.stofanet.dk ([212.10.10.26]:37997 "EHLO mx06.stofanet.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757057AbYCYQAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:00:00 -0400
Message-ID: <47E9217F.5080907@yahoo.co.uk>
Date: Tue, 25 Mar 2008 16:59:59 +0100
From: "Martin B. Andersen" <datscharf@yahoo.co.uk>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: MMC/SD: data CRC errors and unknown SCR version on 2.6.14
References: <47E792D4.7000704@yahoo.co.uk>
In-Reply-To: <47E792D4.7000704@yahoo.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found the solution. It was a problem on my ARM platform at91rm9200 which 
didn't have internal pullup's enabled on the CMD and DAT0..DAT3.
I found it by comparing the patch for AT91 kernel 2.6.19 on 
http://maxim.org.za/at91_26.html with the driver I had backported.

regards
Martin

