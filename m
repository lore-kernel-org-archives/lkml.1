Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbYK2DZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbYK2DZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 22:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYK2DYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 22:24:55 -0500
Received: from main.gmane.org ([80.91.229.2]:40662 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbYK2DYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 22:24:54 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: DMA from memory to local bus
Date: Fri, 28 Nov 2008 21:24:40 -0600
Message-ID: <4930B5F8.6020601@shaw.ca>
References: <62DDBB9E5E23CC4A929EE46F9427CEAF0162468D@BUDMLVEM04.e2k.ad.ge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: maciej.sosnowski@intel.com, dan.j.williams@intel.com
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <62DDBB9E5E23CC4A929EE46F9427CEAF0162468D@BUDMLVEM04.e2k.ad.ge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hommel, Thomas (GE EntSol, Intelligent Platforms) wrote:
> Hi all,
> I'm currently developing a driver and want to make use of the DMA
> offload engine. Data has to be transferred from memory to a device on
> the local bus and vice versa.
> At a first look, the function dma_async_memcpy_buf_to_buf() seemed to be
> suitable, but it does not translate addresses correctly. Both addresses
> are treated as if they were in memory.

That would be the normal use of these things, I believe.. normally when 
copying to/from a device the device does it itself with bus master DMA.

> In my configuration, the buffer is located in memory, but the device's
> I/O space is mapped into vmalloc space via ioremap(). How can I access
> the I/O space corectly from the DMA controller?
> 
> Thanks for your help
> Thomas

