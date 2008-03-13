Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbYCMPnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbYCMPnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 11:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbYCMPng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 11:43:36 -0400
Received: from ns.firmix.at ([62.141.48.66]:1753 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbYCMPnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 11:43:25 -0400
Subject: Re: checkpatch.pl and statics
From: Bernd Petrovitsch <bernd@firmix.at>
To: Andreas Westin XX <andreas.xx.westin@ericsson.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <6006DAC0B81F85439BC960F36F929CDFB5F5EE@eseldmw101.eemea.ericsson.se>
References: <6006DAC0B81F85439BC960F36F929CDFB5F5EE@eseldmw101.eemea.ericsson.se>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Thu, 13 Mar 2008 16:43:09 +0100
Message-Id: <1205422989.3621.22.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.331 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.331 required=5
X-Spam-Score: -2.331 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Don, 2008-03-13 at 16:09 +0100, Andreas Westin XX wrote:
[....]
> I ran checkpatch.pl on a piece of code I wrote and besides all the other
> warnings/errors it complained about a static pointer being initialised
> to NULL/0. I fixed it but I'm curious as to why this is not permitted ?

Because "uninitialized" data is automatically initialized wit 0. An
explicit initialization with 0/NULL wastes space in the kernel image.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


