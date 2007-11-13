Return-Path: <linux-kernel-owner+w=401wt.eu-S1758627AbXKMQKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627AbXKMQKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 11:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754340AbXKMQKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 11:10:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089AbXKMQKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 11:10:36 -0500
Message-ID: <4739CBF0.8000500@redhat.com>
Date: Tue, 13 Nov 2007 11:08:16 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Florian Boelstler <kernel@boelstler.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Strange delays / what usually happens every 10 min?
References: <fhcc39$51b$1@ger.gmane.org>
In-Reply-To: <fhcc39$51b$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Florian Boelstler wrote:
> While running that test driver a delay of about 10ms _exactly_ occurs
> every 10 minutes.

This is precisely the sort of thing that BIOS/firmware-level SMI handlers do, 
particularly those that have monitoring or management features.  Try to 
determine if the kernel is doing anything during this time.  If the entire 
kernel seems to be frozen, talk to the people who wrote the firmware.

	-- Chris
