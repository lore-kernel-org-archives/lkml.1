Return-Path: <linux-kernel-owner+w=401wt.eu-S1753095AbXC0DmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbXC0DmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 23:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbXC0DmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 23:42:18 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:12635 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbXC0DmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 23:42:17 -0400
X-IronPort-AV: i="4.14,331,1170651600"; 
   d="scan'208"; a="32686572:sNHT22016232"
Subject: Re: revoke: no revoke for nommu
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: David Howells <dhowells@redhat.com>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, bryan.wu@analog.com,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <11139.1174911959@redhat.com>
References: <Pine.LNX.4.64.0703261512120.13921@sbz-30.cs.Helsinki.FI>
	 <11139.1174911959@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Tue, 27 Mar 2007 11:42:53 +0800
Message-Id: <1174966973.6966.16.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 13:25 +0100, David Howells wrote:
> Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > There's just no sane way to revoke shared memory mappings for NOMMU so lets
> > disable the thing completely when CONFIG_MMU=n.
> 
> I think that's reasonable for now - we can always add support as far as
> possible later.
> 

Yes, we can test this on Blackfin arch and maybe add support later with
Blackfin MPU.

Thanks
-Bryan
