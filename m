Return-Path: <linux-kernel-owner+w=401wt.eu-S1761107AbXKMU22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761107AbXKMU22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172AbXKMU2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:28:20 -0500
Received: from gw.goop.org ([64.81.55.164]:40989 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038AbXKMU2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:28:19 -0500
Message-ID: <473A0870.4070104@goop.org>
Date: Tue, 13 Nov 2007 12:26:24 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Amit Shah <amit.shah@qumranet.com>
CC: kvm-devel@lists.sourceforge.net,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, zach@vmware.com, lguest@ozlabs.org,
       ak@suse.de, avi@qumranet.com, virtualization@lists.linux-foundation.org,
       akpm@linux-foundation.org
Subject: Re: [kvm-devel] [PATCH 0/24] paravirt_ops for unified x86 - that's
 me again!
References: <11946337851964-git-send-email-gcosta@redhat.com> <200711121347.20050.amit.shah@qumranet.com>
In-Reply-To: <200711121347.20050.amit.shah@qumranet.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Shah wrote:
> Glauber, are you planning on consolidating the dma_ops structure for 32- and 
> 64-bit? 32-bit doesn't currently have a dma_mapping_ops structure, which 
> makes paravirtualizing DMA access difficult on 32-bit.


I think it's a good idea.  While I haven't worked out the details yet,
it seems like something I'll need for Xen dom0 support.

    J
