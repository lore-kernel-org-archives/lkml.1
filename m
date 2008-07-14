Return-Path: <linux-kernel-owner+w=401wt.eu-S1755066AbYGNBFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbYGNBFN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 21:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbYGNBE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 21:04:59 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:11258 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbYGNBE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 21:04:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UI5ani6PUipZrPSw93+JyKHPXXJFMVgUnbLoyiJbFeBS7Fqx4cJrhFMirK5d+115m5
         +tddx7GiSSAPcuMdSzJ2Ur5AJUIhNna5hqj7OoNZFkAeYwvS8waqoyiXn27zm3vRg6Op
         cLQojnHuRmJx2rW6XvxJx9oLjYksoxCQ6YLuc=
Message-ID: <dd18b0c30807131804g6b5b9a5by4468eef8c310cab5@mail.gmail.com>
Date: Mon, 14 Jul 2008 01:04:56 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: [Bug #10954] hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x011f000c
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
In-Reply-To: <15207.1215996628@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
	 <c6ZRbn0adb.A.si.HIleIB@albercik>
	 <15207.1215996628@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 12:50 AM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Sun, 13 Jul 2008 20:00:46 +0200, "Rafael J. Wysocki" said:
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.25.  Please verify if it still should be listed.
>>
>>
>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=10954
>> Subject               : hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x011f000c
>> Submitter     : Justin Mattock <justinmattock@gmail.com>
>> Date          : 2008-06-21 2:05 (23 days old)
>> References    : http://marc.info/?l=linux-kernel&m=121401399622190&w=4
>>                 http://marc.info/?t=121416231700010&r=1&w=4
>
> Not sure if it's the same bug or not, this one's been there since before
> 2.6.25 but I haven't bothered chasing it down before. It's still in 26-rc9-mmotd.
>
> Jul 13 05:53:47 turing-police kernel: [ 1459.168266] ALSA sound/pci/hda/hda_intel.c:588: hda_intel: No response from codec, disabling MSI: last cmd=0x012f1c00
> Jul 13 05:53:48 turing-police kernel: [ 1460.169265] ALSA sound/pci/hda/hda_intel.c:601: hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x012f1c00
>
> Dell Latitude D820, x86_64 kernel.  Audio device is:
>
> 00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 01)
>
> dmidecode says it's a "Sigmatel 9200".
>
> I've been lazy chasing this one, because all that happens is that MSI gets
> turned off, and it keeps going without it...
>

Could be.
Yeah I must admit too about being lazy with this one;
(spent a few days updating my system with SID);
With Googling a little bit, isn't msi disabled by default?
if not then maybe setting the boot param is something to look into,
as well as tweaking the .config.

-- 
Justin P. Mattock
