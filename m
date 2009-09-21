Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbZIUJnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbZIUJnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 05:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767AbZIUJnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 05:43:15 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:61309 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740AbZIUJnO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 05:43:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Mn3tJoAf/wx8hDexL1kpWA8BquJVZ3bg/SuJzFX0+mvdvNCIThsrfoJQL0THuVmA3H
         sloGXilj/57NWmbV365ctGnk23iIXf5+R76mKeK7I7WTbYV5UhgZFm3B5cHRa99qM21z
         RQaOnTmmig78+f3LcqUaAXYlnP4zwRN3k2T1g=
MIME-Version: 1.0
In-Reply-To: <200909202035.54220.gene.heskett@verizon.net>
References: <c43b2e150909200120kf87cdc2oabafea8abbf01227@mail.gmail.com>
	 <200909201637.52514.gene.heskett@verizon.net>
	 <68676e00909201431j43402470g70df5519a963097b@mail.gmail.com>
	 <200909202035.54220.gene.heskett@verizon.net>
Date: Mon, 21 Sep 2009 11:43:16 +0200
Message-ID: <68676e00909210243h7aab926cr225779826743ed33@mail.gmail.com>
Subject: Re: [lm-sensors] it87 sensors need an ACPI driver (2.6.31)
From: Luca Tettamanti <kronos.it@gmail.com>
To: Gene Heskett <gene.heskett@verizon.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 2:35 AM, Gene Heskett <gene.heskett@verizon.net> wrote:
> On Sunday 20 September 2009, Luca Tettamanti wrote:
>>On Sun, Sep 20, 2009 at 10:37 PM, Gene Heskett <gene.heskett@verizon.net>
> wrote:
>>> Jumping in the middle of this, I am another that it87 doesn't work very
>>> well for,  ASUS M2N SLI Deluxe board.
>>
>>Please define "doesn't work well". asus_atk0110 should handle that
>>board. In case of troubles enable CONFIG_HWMON_DEBUG_CHIP, load
>>asus_atk0110 and post the content of the kernel log.
>>
> With that CONFIG_HWMON_DEBUG_CHIP enabled, dmesg (attached) looks semi-
> kosher, but neither gkrellm nor sensors can show me data until it87 is
> loaded.  I unloaded it87 and reloaded it several times just now.  Something
> funkity someplace...  Is there a new application I need to dl and install?

You probably need to upgrade the lm-sensors package. Version 3.1.1 has
support for ACPI devices.

Luca
