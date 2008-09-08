Return-Path: <linux-kernel-owner+w=401wt.eu-S1752901AbYIHBN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbYIHBN7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 21:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbYIHBNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 21:13:51 -0400
Received: from hpsmtp-eml15.kpnxchange.com ([213.75.38.115]:6227 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504AbYIHBNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 21:13:51 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: [regression] __tick_program_event of hpet is stuck
Date: Mon, 8 Sep 2008 03:13:48 +0200
User-Agent: KMail/1.9.9
References: <200809080114.36106.elendil@planet.nl>
In-Reply-To: <200809080114.36106.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809080313.48910.elendil@planet.nl>
X-OriginalArrivalTime: 08 Sep 2008 01:13:49.0319 (UTC) FILETIME=[263A7170:01C91150]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2008, Frans Pop wrote:
> With current git head (v2.6.27-rc5-319-g7686ad5) I'm seeing repeated
> occurrences of the following on my HP Compaq 2510p laptop. Not seen
> with earlier kernels, including 2.6.27-rc5.

I meant repeated as in "after different boots", but I now also see repeats 
when I leave the system on for some time. It keeps increasing the 
min_delta_ns to ever higher values.

CE: __tick_program_event of hpet is stuck 1468f1b3c9 1468f1c751
CE: increasing min_delta_ns 5000 to 10000 nsec
[...]
CE: __tick_program_event of hpet is stuck 33576032f74 33576035684
CE: increasing min_delta_ns 10000 to 20000 nsec
[...]
CE: __tick_program_event of hpet is stuck 63242b30d28 63242b35b48
CE: increasing min_delta_ns 20000 to 40000 nsec

The call trace is basically the same each time.
