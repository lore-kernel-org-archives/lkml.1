Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbYDESGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbYDESGI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 14:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbYDESF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 14:05:56 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:40639 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbYDESFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 14:05:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GBaW2sVwl7QuoAXjbankkbgFekNyQ8GUuI4F4ZUzP6xGCeuWRCaI5UP7xqYHe+YsRyb1EQt8I/BnRYzX1+sQzcPQGAkfGRNCUpxSlImDSKP6hDzmSyBWuRRqR25+aVSga2v4p+/oTFOv6leW7lVZb9IiipbedAg/WPTnyiBTvKY=
Message-ID: <5681ec900804051105k4183a005k448b39e51d03f387@mail.gmail.com>
Date: Sat, 5 Apr 2008 23:35:51 +0530
From: "Sanjeev Aditya Naga" <sanjeev.kernel@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [>=2.6.23][BUG] Oops on power disconnection
Cc: trenn@suse.de, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       "Li, Shaohua" <shaohua.li@intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEED0EA3C@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <5681ec900803300645l5369cda4g119957a4b7f05d17@mail.gmail.com>
	 <5681ec900803300651m6e5f38deke1b7746236e5bb9@mail.gmail.com>
	 <20080402001418.aad6eed2.akpm@linux-foundation.org>
	 <5681ec900804020608o62be52c4ted172e18daf24f5b@mail.gmail.com>
	 <1207147729.30061.9.camel@hammer1.suse.de>
	 <5681ec900804020913t4adc38b1r2e424fa8bbdda241@mail.gmail.com>
	 <1207159974.4700.6.camel@queen.suse.de>
	 <5681ec900804030915w720f3ccfp74e5d501ca3d6b56@mail.gmail.com>
	 <1207256678.6024.90.camel@linux-2bdv.site>
	 <924EFEDD5F540B4284297C4DC59F3DEED0EA3C@orsmsx423.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m35I6onq021097

Hello Venki,
On Fri, Apr 4, 2008 at 6:01 AM, Pallipadi, Venkatesh<venkatesh.pallipadi@intel.com> wrote:>>>>  >-----Original Message----->  >From: Thomas Renninger [mailto:trenn@suse.de]>  >Sent: Thursday, April 03, 2008 2:05 PM>  >To: Sanjeev Aditya Naga>  >Cc: Andrew Morton; linux-kernel@vger.kernel.org;>  >linux-acpi@vger.kernel.org; Pallipadi, Venkatesh; Li, Shaohua>  >Subject: Re: [>=2.6.23][BUG] Oops on power disconnection>  >>  >>  >On Thu, 2008-04-03 at 21:45 +0530, Sanjeev Aditya Naga wrote:>  >> Hello Thomas,>  >>>  >> On Wed, Apr 2, 2008 at 11:42 PM, Thomas Renninger>  ><trenn@suse.de> wrote:>  >> >>  >> > On Wed, 2008-04-02 at 21:43 +0530, Sanjeev Aditya Naga wrote:>  >> >  > Hello Thomas,>  >> >  >>  >> >  > > Hi,>  >> >  > >>  >> >  > >>  >> >  > >  On Wed, 2008-04-02 at 18:38 +0530, Sanjeev Aditya Naga wrote:>  >> >  > >  > Hello Andrew Morton,>  >> >  > >  >>  >> >  > >  > Greetings!>  >> >  > >  >>  >> >  > >  > Thank you for the update. Is there anything I can do>  >> >  > >  > from my side?>  >> >  > >  >>  >> >  > >  > I thought it was a acpi (dsdt) problem. And based on>  >> >  > >  > a tutorial, I have tried to extract, fix,>  >recompile the dsdt>  >> >  > >  > and use it with the kernel. But still I have the>  >same problem.>  >> >  > >  > Let me know if I shall attach the dsdt (original)>  >decompiled>  >> >  > >  > code, if that helps.>  >> >  > >>  >> >  > >  this could be due a general memory corruption>  >problem through ACPICA.>  >> >  > >  If you get different backtraces on reboots even you>  >only modified things>  >> >  > >  that do not have to do with the problem, it's>  >probably that and related>  >> >  > >  to:>  >> >  > >  ï»¿http://bugzilla.kernel.org/show_bug.cgi?id=10339>  >> >  > >>  >> >  > >  You might want to try the latest kernel or the patch>  >posted there.>  >> >  >>  >> >  > Thank you for the update.>  >> >  > I have checked the bug and unfortunately its not the>  >> >  > same issue. Things work absolutely fine, when I'm>  >> >  > running on AC power. It even displays the exact>  >> >  > battery (and charging) status to me. It messes up>  >> >  > when suddenly AC power gets disconnected and>  >> >  > switches to battery mode (The time when I get Oops).>  >> >  > The system is still usable after switching to battery>  >> >  > mode and I still get correct battery stats until its>  >> >  > completely discharged. However most of the commands>  >> >  > like kill, poweroff, java doesn't work after the Oops.>  >> >  The bug is not related to battery, but to AML parsing and>  >can therefore>  >> >  affect anything which is ACPI related.>  >> >>  >> >>  >> >  > BTW there is one similarity with the referenced bug.>  >> >  > If I boot the computer without AC Power, it gives the>  >> >  > same Oops and stops during booting itself.>  >> >  >>  >> >  > I shall try the latest kernel once and shall update you.>  >> >  That would be great.>  >> >  If it works, please give the patch there a try, IMO this>  >one should see>  >> >  2.6.2[34].X stable kernels soon.>  >>>  >> I have got the lastest kernel 2.6.25-rc8 today. I observed that>  >> the referenced patch is already in the kernel. However this didn't>  >> solve the problem in question. I get the same Oops on this kernel>  >> as well. Find the latest dmesg along with the Oops:>  >Ok.>  >Maybe best is you document the backtraces/oopses with kernel>  >versions at>  >bugzilla.kernel.org and add dmesg and acpidump.>  >It seems your machine notifies OS that the C-state table changed.>  >AFAIK this is rare and there might be a general bug in the>  >cpuidle layer>  >which I do not know well.>  >Best you add Venkatesh and Shaohua Li <shaohua.li@intel.com> to CC of>  >the bug.>  >While the backtrace shows a lot, cpuidle IMO is missing a general debug>  >option like in the cpufreq layer.>  >I couldn't find a single printk in the whole cpuidle/{cpuidle,sysfs}.c>  >files, even on error paths. ï»¿Also in the cpuidle specific parts of>  >drivers/acpi/processor_idle.c some debug printks may help for>  >future bug>  >reports. It is very hard to guess what happened...>  >>>  This looks like cpuidle and kobject interaction.>  The latest oops looks different from the original one. Latest one is a>  warn_on in lib/kref.c:43>>  We (Me or Shaohua) will take a deeper look at get back on this.

Thank you for the update. Let me know if I can be of any help!
Kind Regards,Sanjeev
>>  Thanks,>  Venki>>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
