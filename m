Return-Path: <linux-kernel-owner+w=401wt.eu-S1757829AbZDXScH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829AbZDXScH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 14:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbZDXSbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 14:31:55 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:62101 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751794AbZDXSby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 14:31:54 -0400
From: Frans Pop <elendil@planet.nl>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [BUG] 2.6.30-rc3: bnx2 failing to load firmware
Date: Fri, 24 Apr 2009 20:31:51 +0200
User-Agent: KMail/1.9.9
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       mchan@broadcom.com, davem@davemloft.net
References: <alpine.LFD.2.00.0904212014170.3101@localhost.localdomain> <alpine.LFD.2.00.0904212014170.3101@localhost.localdomain> <20090424175238.GA19646@csn.ul.ie>
In-reply-To: <20090424175238.GA19646@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904242031.52793.elendil@planet.nl>
X-OriginalArrivalTime: 24 Apr 2009 18:31:53.0128 (UTC) FILETIME=[F0747A80:01C9C50A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like you're using an initramfs initrd and the bnx2 module is getting 
loaded at that stage. Have you checked that the bnx firmware file is 
included in your initramfs?

Cheers,
FJP
