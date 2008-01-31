Return-Path: <linux-kernel-owner+w=401wt.eu-S1761533AbYAaGPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761533AbYAaGPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 01:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYAaGP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 01:15:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46778 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbYAaGP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 01:15:27 -0500
Message-ID: <47A16616.9070606@zytor.com>
Date: Wed, 30 Jan 2008 22:09:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Yinghai Lu <Yinghai.Lu@Sun.COM>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: system without RAM on node0 boot fail
References: <200801302026.27130.yinghai.lu@sun.com> <200801302102.09510.yinghai.lu@sun.com> <Pine.LNX.4.64.0801302049180.15109@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0801302049180.15109@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> x86 supports booting from a node without RAM?

 From the looks of it I would say he probably has the boot node numbered 1.

The e820 map is also "interesting" - doesn't list the first 256 bytes, 
which corresponds to the first quarter(!) of the real-mode exception table.

	-hpa
