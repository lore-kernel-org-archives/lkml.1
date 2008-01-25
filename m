Return-Path: <linux-kernel-owner+w=401wt.eu-S1757147AbYAYL4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbYAYL4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 06:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbYAYL41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 06:56:27 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:41318 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbYAYL40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 06:56:26 -0500
Message-ID: <4799CE68.5020305@s5r6.in-berlin.de>
Date: Fri, 25 Jan 2008 12:56:24 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Frank Seidel <fseidel@suse.de>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 012/196] nozomi driver
References: <20080125071127.GA4860@kroah.com> <1201245134-4876-12-git-send-email-gregkh@suse.de> <Pine.LNX.4.64.0801250910230.12676@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0801250910230.12676@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/2008 9:31 AM, Jan Engelhardt wrote:
> On Jan 24 2008 23:09, Greg Kroah-Hartman wrote:
>>+#ifdef __BIG_ENDIAN
>>+/* Big endian */
>>+
>>+struct toggles {
>>+	unsigned enabled:5;	/*
>>+				 * Toggle fields are valid if enabled is 0,
>>+				 * else A-channels must always be used.
>>+				 */
>>+	unsigned diag_dl:1;
>>+	unsigned mdm_dl:1;
>>+	unsigned mdm_ul:1;
>>+} __attribute__ ((packed));
> 
> Probably just me, unsigned int is a good bit more explicit.
> The driver may also use a combined struct with
> BIG_ENDIAN_BITFIELD/LITTLE_ENDIAN_BIGFIELD (see e.g. linux/ip.h).

I've been told we don't do bitfields anymore in on-the-wire data,
on-disk data, userspace ABIs, etc. because their layout is compiler
dependent in the end.
-- 
Stefan Richter
-=====-==--- ---= ==--=
http://arcgraph.de/sr/
