Return-Path: <linux-kernel-owner+w=401wt.eu-S1758361AbXLGXKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361AbXLGXKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 18:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756635AbXLGXKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 18:10:30 -0500
Received: from smtp-out.google.com ([216.239.33.17]:6131 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683AbXLGXK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 18:10:28 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=woOFdQixwj5mzmo+SnHlQmlmK0ufEbCdWF1VwGxtecxFhdlbaaN8xZhjo3zPz7rAd
	Su07zJ9SMUJGznynYG6mA==
Date: Fri, 7 Dec 2007 15:10:07 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Kumar Gala <galak@kernel.crashing.org>, Olof Johansson <olof@lixom.net>,
       linuxppc-dev@ozlabs.org, magnus.damm@gmail.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC
In-Reply-To: <4759C548.6030304@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.0.9999.0712071508460.27689@chino.kir.corp.google.com>
References: <20071207211425.10223.91240.sendpatchset@balbir-laptop> <20071207212817.GA391@lixom.net> <4759BCA2.1020809@linux.vnet.ibm.com> <975B5B2B-C1F3-4021-9AE2-8873FFE1BDEC@kernel.crashing.org> <4759C548.6030304@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007, Balbir Singh wrote:

> To be able to test the memory controller under NUMA, I use fake NUMA
> nodes. x86-64 has a similar feature, the code I have here is the
> simplest I could come up with for PowerPC.
> 

Magnus Damm had patches from over a year ago that, I believe, made much of 
the x86_64 fake NUMA code generic so that it could be extended for 
architectures such as i386.  Perhaps he could resurrect those patches if 
there is wider interest in such a tool.
