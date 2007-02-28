Return-Path: <linux-kernel-owner+w=401wt.eu-S1752226AbXB1RgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbXB1RgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 12:36:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbXB1RgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 12:36:05 -0500
Received: from de01egw01.freescale.net ([192.88.165.102]:46120 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbXB1RgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 12:36:03 -0500
Message-ID: <45E5BD6B.1010509@freescale.com>
Date: Wed, 28 Feb 2007 11:35:39 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; it; rv:1.8.1) Gecko/20061010 Firefox/2.0 
MIME-Version: 1.0
To: Dan Malek <dan@embeddedalley.com>
CC: Torben.Mathiasen@hp.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       linux-ppc-embedded <linuxppc-embedded@ozlabs.org>
Subject: Re: lanana: Add major/minor entries for PPC QE UART devices
References: <45E46976.6060600@freescale.com>	<29c13109971547687159078eacdea008@kernel.crashing.org>	<45E592DC.9060700@freescale.com>	<511cacb7bbe8a65ff72738c84ec9ece4@kernel.crashing.org>	<BD465924-7387-47EF-B90F-606F215819C2@embeddedalley.com>	<45E5B604.904@freescale.com> <46F6BF70-2922-4E05-8DAB-6B0830B0AB47@embeddedalley.com>
In-Reply-To: <46F6BF70-2922-4E05-8DAB-6B0830B0AB47@embeddedalley.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Malek wrote:

> I don't think that would be a problem, and I'd like the
> CPM/QE to share devices because it makes the
> software distributions common to all Freescale
> embedded processors.

I'm willing to use whatever minor number and range the community agrees upon.

An alternative idea, which one person already shot down, was to allow only 4 devices 
normally, but allow more devices if you use udev, since udev doesn't care about minor 
number assignments.  This eliminates the overlap and encourages people to use udev.

-- 
Timur Tabi
Linux Kernel Developer @ Freescale
