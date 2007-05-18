Return-Path: <linux-kernel-owner+w=401wt.eu-S1760540AbXERTSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760540AbXERTSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 15:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbXERTSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 15:18:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737AbXERTSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 15:18:06 -0400
Message-ID: <464DFBE0.5060904@redhat.com>
Date: Fri, 18 May 2007 15:17:52 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: eugene@ns.armcci.am
CC: linux-kernel@vger.kernel.org
Subject: Re: ht CPU flag
References: <Pine.LNX.4.64.0705182131030.25685@ns.armcci.am>
In-Reply-To: <Pine.LNX.4.64.0705182131030.25685@ns.armcci.am>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

eugene@ns.armcci.am wrote:
> ---------------------------------------------------------------------------
> 
> I have Pentium D CPU, which many Windows utilities like cpuz, wcpuid, 
> everest identify as D 930 (Dual Core, 3GHz). From Intel site I find out 
> that it has no HT feature, nor Windows XP identify it as HT.
> 
> Why do I have "ht" flag in cpuinfo?
> -----------------------------------

The "ht" flag merely means "I know how to report hyperthreaded logical 
processors if I have them."  My Woodcrest Xeon 5110 and my Athlon64 X2 both have 
the "ht" flag, and correctly report the zero hyperthreaded logical processors 
they each have.

	-- Chris
