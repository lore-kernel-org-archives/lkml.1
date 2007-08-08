Return-Path: <linux-kernel-owner+w=401wt.eu-S1763988AbXHHJs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763988AbXHHJs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 05:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757212AbXHHJsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 05:48:19 -0400
Received: from cluster-d.mailcontrol.com ([217.69.20.190]:55321 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949AbXHHJsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 05:48:18 -0400
Message-ID: <46B990F0.2020001@csr.com>
Date: Wed, 08 Aug 2007 10:46:24 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch 2/4] sdio: set the functions' block size
References: <11858961933491-git-send-email-david.vrabel@csr.com>	<20070804152304.65ed8f1b@poseidon.drzeus.cx>	<46B6F877.7060504@csr.com>	<20070806171207.59fafa18@poseidon.drzeus.cx>	<46B73F18.5030109@csr.com>	<20070806220145.66b97559@poseidon.drzeus.cx>	<46B86ADB.90000@csr.com>	<46B86B88.5050009@csr.com>	<20070807153800.734a6cbf@poseidon.drzeus.cx>	<46B8A9DA.9030804@csr.com> <20070807195445.62d107e2@poseidon.drzeus.cx>
In-Reply-To: <20070807195445.62d107e2@poseidon.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Aug 2007 09:46:34.0863 (UTC) FILETIME=[01ED27F0:01C7D9A1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> 
>> A driver might enable/disable a function multiple
>> times but there's no need to set the block size every time.
> 
> Why would it want to do that?

A function enable/disable cycle should act as a per-function reset.

David
-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.
