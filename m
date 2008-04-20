Return-Path: <linux-kernel-owner+w=401wt.eu-S1760426AbYDTMbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760426AbYDTMbf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 08:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbYDTMb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 08:31:28 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:40050 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbYDTMb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 08:31:27 -0400
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: mingo@elte.hu, airlied@linux.ie,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Make CONFIG_ARP=m under x86_64
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.LNX.1.10.0804182304040.26385@fbirervta.pbzchgretzou.qr>
Date: Sun, 20 Apr 2008 14:30:37 +0200
In-Reply-To: <alpine.LNX.1.10.0804182304040.26385@fbirervta.pbzchgretzou.qr> (Jan Engelhardt's message of "Fri, 18 Apr 2008 23:21:44 +0200 (CEST)")
Message-ID: <87r6d0aetu.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Apr 2008 12:23:49.0080 (UTC) FILETIME=[62E86D80:01C8A2E1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@computergmbh.de> writes:

> when you want to use nvagp instead which requries agpgart to be 
> unloadable.

The patch is wrong. GART_IOMMU cannot be modular. It has to be 
initialized early.

-Andi
