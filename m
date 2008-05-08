Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbYEHPgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbYEHPgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 11:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763440AbYEHPfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 11:35:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43057 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763325AbYEHPfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 11:35:38 -0400
Message-ID: <48231DC8.50600@garzik.org>
Date: Thu, 08 May 2008 11:35:36 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: linux-next does not find root partition on PATA ICH5
References: <fvv4m2$mp1$1@ger.gmane.org>
In-Reply-To: <fvv4m2$mp1$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sitsofe Wheeler wrote:
> Trying to boot a linux-next kernel (git cloned today) never seems to find
> the root partition. Putting the PATA drivers and ext3 components into the
> kernel image rather than modules makes no difference. Near enough the same
> config boots on 2.6.26rc1 (git pulled today).
> 
> Apologies for posting this to the main kernel list - the linux-next list
> doesn't yet appear to be fully on GMANE (
> http://dir.gmane.org/gmane.linux.kernel.next ) or Google Groups...
> 
> lspci for the IDE interface:
> 00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE
> Controller (rev 02)
> 00:1f.2 IDE interface: Intel Corporation 82801EB (ICH5) SATA Controller (rev
> 02)
> 
> The kernel config used is on
> http://sucs.org/~sits/test/kernel-config-20080508 .

Check out the patch CC'd to you in another thread ("Re: [git patches] 
libata updates[...]")

	Jeff



