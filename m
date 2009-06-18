Return-Path: <linux-kernel-owner+w=401wt.eu-S1764070AbZFROJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764070AbZFROJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 10:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760832AbZFROI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 10:08:59 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.27]:41671 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131AbZFROI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 10:08:59 -0400
X-Greylist: delayed 2052 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Jun 2009 10:08:59 EDT
References: <20090616205747.GA6356@rhlx01.hs-esslingen.de> <20090617001435.e2d86780.peter@piie.net> <20090617122022.GA13141@rhlx01.hs-esslingen.de> <cone.1245309039.632882.31537.1000@arca> <9ea470500906180329w7c8975b0ra60fa219221d53f6@mail.gmail.com> <cone.1245322548.289821.31537.1000@arca> <9ea470500906180442r7beb49a8odcb3bf602df78b47@mail.gmail.com> <cone.1245325770.489357.31537.1000@arca> <9ea470500906180545j5e1a78f7qcb887ad843b489f3@mail.gmail.com> <cone.1245331895.30957.31537.1000@arca> <20090618135457.GA927@rhlx01.hs-esslingen.de>
Message-ID: <cone.1245333947.155956.30118.1000@arca>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <pfe@piie.net>
To: Andreas Mohr <andi@lisas.de>
Cc: Borislav Petkov <petkovbb@googlemail.com>, Ed Tomlinson <edt@aei.ca>,
       akpm@linux-foundation.org, Len Brown <len.brown@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Request driver inclusion - acer aspire one fan control
Date: Thu, 18 Jun 2009 16:05:47 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andreas Mohr writes:

> Hi,
> 
> On Thu, Jun 18, 2009 at 03:31:35PM +0200, Peter Feuerer wrote:
>> You are partly right, setting the fan to auto in  
>> "acerhdf_revert_to_bios_mode" can be removed, as this is done by the 
>> thermal layer when calling "acerhdf_set_cur_state" with 
>> disable_kernelmode=1.
> 
> No, it was done _specifically_ this way to make sure that _exactly when_
> switching away from kernel mode FAN_AUTO _always_ (by asking people to
> always call this central function) gets set, too.
> I don't want to depend on a separate, _uncontrollable_ entity
> (thermal layer function) to have to run sometime later
> in order to set the fan to FAN_AUTO (IOW, BIOS-controlled mode) accordingly.
> _Of course_ this FAN_AUTO call is redundant in _most_ cases, but very
> intentionally so. Anything else would be woefully unsafe (with a fan
> remaining in FAN_OFF position until machine meltdown).

Ok, that sounds reasonable.

--peter
