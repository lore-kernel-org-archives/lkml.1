Return-Path: <linux-kernel-owner+w=401wt.eu-S1752402AbZCIOMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbZCIOMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 10:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbZCIOM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 10:12:29 -0400
Received: from mx0.towertech.it ([213.215.222.73]:36649 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751186AbZCIOM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 10:12:28 -0400
Date: Mon, 9 Mar 2009 15:12:16 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: Geert.Uytterhoeven@sonycom.com, Kyle McMartin <kyle@mcmartin.ca>,
       linux-parisc@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>, Dann Frazier <dannf@dannf.org>,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: [rtc-linux] [PATCH 7/7] powerpc/ps3: Add rtc-ps3
Message-ID: <20090309151216.17f13862@i1501.lan.towertech.it>
In-Reply-To: <1236605183-22718-8-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1236605183-22718-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<1236605183-22718-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<1236605183-22718-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<1236605183-22718-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<1236605183-22718-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<1236605183-22718-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<1236605183-22718-7-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<1236605183-22718-8-git-send-email-Geert.Uytterhoeven@sonycom.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 Mar 2009 14:26:23 +0100
Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

 Hi,

   just a few notes:

> +
> +static int ps3_get_time(struct device *dev, struct rtc_time *tm)
> +{
> +	to_tm(read_rtc() + ps3_os_area_get_rtc_diff(), tm);
> +	tm->tm_year -= 1900;
> +	tm->tm_mon -= 1;
> +	return 0;
> +}

 this should be return rtc_valid_tm() .

 can't you use functions from rtc-lib.c instead of 
 that to_tm ?

> +
> +MODULE_AUTHOR("Sony Corporation");

 real name, if possible and a contact address
 here . Just in case I need someone to bother :)

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

