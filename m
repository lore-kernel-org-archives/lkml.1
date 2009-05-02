Return-Path: <linux-kernel-owner+w=401wt.eu-S1757988AbZEBRFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988AbZEBRFs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 13:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbZEBRFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 13:05:37 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52945 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927AbZEBRFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 13:05:36 -0400
Message-ID: <49FC7D5E.6050203@garzik.org>
Date: Sat, 02 May 2009 13:05:34 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Lubomir Rintel <lkundrak@v3.sk>
CC: netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: [PATCH] Do not register ne2k-pci device until initialized
References: <1241281735.2641.7.camel@localhost.localdomain>
In-Reply-To: <1241281735.2641.7.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lubomir Rintel wrote:
> Doing it in reverse order causes uevent to be sent before
> we have a MAC address, which confuses udev.
> 
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>

Acked-by: Jeff Garzik <jgarzik@redhat.com>

Good spotting, that fixes a clear startup race


