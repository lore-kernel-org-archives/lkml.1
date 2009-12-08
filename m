Return-Path: <linux-kernel-owner+w=401wt.eu-S935755AbZLHDQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935755AbZLHDQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 22:16:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934534AbZLHDQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 22:16:05 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:59144 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934700AbZLHDQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 22:16:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=IPFmWPZLl/38X5xM+N19xPiIv1YQoGW7qN3riKuqU2MQOQxeK/XYQaG8w5i4U9EU48
         SUyiTKctDQOgZAcKcrpYO+kZ9S2NjyPmBxFgWiFaEtjUwm9hdKZL4rcKY2i5XkxZVVEN
         MaVbGowO0rFoOk1Zqj62p57IA4FFtPxf6bKkM=
Message-ID: <4B1DC4F0.9050708@gmail.com>
Date: Mon, 07 Dec 2009 21:16:00 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091203 Fedora/3.0-3.13.rc2.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Andy Isaacson <adi@hexapodia.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Richard Zidlicky <rz@linux-m68k.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.32 regression, hard lock
References: <20091206141419.GA6195@linux-m68k.org> <20091207143057.53c6a362.akpm@linux-foundation.org> <20091208004221.GA15968@hexapodia.org>
In-Reply-To: <20091208004221.GA15968@hexapodia.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2009 06:42 PM, Andy Isaacson wrote:
> On Mon, Dec 07, 2009 at 02:30:57PM -0800, Andrew Morton wrote:
>> btw, why does your kernel say "To Be Filled By O.E.M." in the traces?
>> The kernel.org kernel doesn't do that.  Is that kernel patched at all?
>
> That's traditional for DMI_PRODUCT_NAME in dodgy vendor BIOSes.  I
> routinely see it on Intel evaluation boards and less frequently on
> Taiwanese Brand X boards.

It seems like the DMI board product name would be more useful than the 
system product name to print out in those messages (for kerneloops.org 
use, etc) as the system name is so frequently populated with such dummy 
values. My Asus P7P55D has the product name set to "System Product Name" 
which obviously isn't very unique or useful. Most likely only big-name 
manufactured systems would have a chance of filling that in properly.
