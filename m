Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935123Ab0CMKh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 05:37:28 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:50566 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933354Ab0CMKh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 05:37:27 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B9B6ADC.6060204@s5r6.in-berlin.de>
Date: Sat, 13 Mar 2010 11:37:16 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Lars Lindley <lindley@coyote.org>
CC: Pavel Machek <pavel@ucw.cz>, gregkh@suse.de, penberg@cs.helsinki.fi,
       diegoliz@gmail.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: Formatting, whitespace etc in mds.c
 I fixed most of the problems found by checkpatch.pl. Some long lines are
 left and some KERN_.. Signed-off-by: Lars Lindley <lindley@coyote.org>
References: <1268430337-18192-1-git-send-email-lindley@coyote.org> <20100313063109.GB12554@elf.ucw.cz> <4B9B6409.3070502@coyote.org>
In-Reply-To: <4B9B6409.3070502@coyote.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars Lindley wrote:
> +		} else { /*DSSS*/
> +			/*CTS duration
> +			 *2 SIFS + DATA transmit time + 1 ACK
> +			 * Rate : ?? Mega bps
> +			 *ACK frame length = 14 bytes*/
> +			if (pT01->T01_plcp_header_length) /*long preamble*/
> +			    Duration = LONG_PREAMBLE_PLUS_PLCPHEADER_TIME*2;
>  			else
> -				Duration = SHORT_PREAMBLE_PLUS_PLCPHEADER_TIME*2;
> +			    Duration = SHORT_PREAMBLE_PLUS_PLCPHEADER_TIME*2;

Multiline comments are formatted as
/*
 * 1st line
 * last line
 */
in new code.

The whitespace in the if--else clause went worse.  Indent by tabs, not
spaces.  Furthermore, there should be spaces around * operators.

(BTW, winbond/README alias winbond/TODO doesn't mention it, but another
(trivial) step is going to be to change variable names and function
names from CamelCase to lower_case spelling.)
-- 
Stefan Richter
-=====-==-=- --== -==-=
http://arcgraph.de/sr/
