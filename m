Return-Path: <linux-kernel-owner+w=401wt.eu-S965854AbXILKth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965854AbXILKth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 06:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762687AbXILKt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 06:49:29 -0400
Received: from poesci.dolphinics.no ([81.175.23.36]:55741 "EHLO
	poesci.dolphinics.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486AbXILKt2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 06:49:28 -0400
To: Dag-Erling =?iso-8859-1?Q?Sm=F8rgrav?= <des@linpro.no>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC+PATCH] RTC calibration
References: <ujrmyvt2tyy.fsf@false.linpro.no>
From: Arne Georg Gleditsch <argggh@dolphinics.no>
Date: Wed, 12 Sep 2007 12:49:59 +0200
In-Reply-To: <ujrmyvt2tyy.fsf@false.linpro.no> ("Dag-Erling
 =?iso-8859-1?Q?Sm=F8rgrav=22's?= message of "Tue\, 11 Sep 2007 15\:48\:53
 +0200")
Message-ID: <kjmsl5krwdk.fsf@pelargir.dolphinics.no>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.0 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dag-Erling Smørgrav <des@linpro.no> writes:
> +	case RTC_SPEED_UP:
> +		err = rtc_speed_up(rtc);
> +		break;
> +
> +	case RTC_SLOW_DOWN:
> +		err = rtc_speed_up(rtc);
> +		break;

This doesn't look quite right.  rtc_slow_down, surely?

-- 
								Arne.
