Return-Path: <linux-kernel-owner+w=401wt.eu-S1758014AbXLGXH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbXLGXH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 18:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbXLGXHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 18:07:17 -0500
Received: from smtp-out.google.com ([216.239.33.17]:5504 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506AbXLGXHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 18:07:15 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=Er9myjpmBTju7MPjmoWFqS7CmhYSC0vZq1Pvm5pXc0EVTSaxFioZaMfE79NlaBm7j
	C0jklleYTL9pBlutX8U/w==
Date: Fri, 7 Dec 2007 15:06:55 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Olof Johansson <olof@lixom.net>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC
In-Reply-To: <20071207212817.GA391@lixom.net>
Message-ID: <alpine.DEB.0.9999.0712071505100.27689@chino.kir.corp.google.com>
References: <20071207211425.10223.91240.sendpatchset@balbir-laptop> <20071207212817.GA391@lixom.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Dec 2007, Olof Johansson wrote:

> > Comments are as always welcome!
> 
> Care to explain what this is useful for? (Not saying it's a stupid idea,
> just wondering what the reason for doing it is).
> 

Fake NUMA has always been useful for testing NUMA code without having to 
have a wide range of hardware available to you.  It's a clever tool on 
x86_64 intended for kernel developers that simply makes it easier to test 
code and adds an increased level of robustness to the kernel.  I think 
it's a valuable addition.
