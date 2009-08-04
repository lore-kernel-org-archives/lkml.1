Return-Path: <linux-kernel-owner+w=401wt.eu-S933602AbZHDXiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602AbZHDXiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 19:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385AbZHDXiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 19:38:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:34999 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907AbZHDXiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 19:38:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,324,1246863600"; 
   d="scan'208";a="713939052"
Subject: Re: iwlwifi (4965) regression since 2.6.30
From: reinette chatre <reinette.chatre@intel.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       hmh@hmh.eng.br
In-Reply-To: <20090804225626.GZ3382@ics.muni.cz>
References: <20090726075738.GA21333@ics.muni.cz>
	 <1248710618.1216.452.camel@rc-desk>
	 <1248710775.9958.0.camel@johannes.local>
	 <20090728112102.GA3382@ics.muni.cz> <1249336021.30019.4304.camel@rc-desk>
	 <20090804084903.GV3382@ics.muni.cz> <1249426183.30019.4581.camel@rc-desk>
	 <20090804225626.GZ3382@ics.muni.cz>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 16:38:01 -0700
Message-Id: <1249429081.30019.4588.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 15:56 -0700, Lukas Hejtmanek wrote:
> On Tue, Aug 04, 2009 at 03:49:43PM -0700, reinette chatre wrote:
> > This is strange. My previous test results were based on recent
> > wireless-testing. I now retested with a fresh pull from Linus's repo
> > (2.6.31-rc5) and I see the same behavior with Fn+F5 not changing the
> > wifi radio status at all. I do not know why we would see different
> > behavior considering we have the same platform and running the same
> > kernel. I found one related option in the BIOS, but with that I was only
> > able to have wireless HW rfkill permanently enabled.
> > 
> > I am not sure about the original problem though. In your original report
> > you mention that you are unable to use wireless due to rfkill. From your
> > email it seems that you are able to toggle wifi rfkill state using the
> > Fn+F5 keys, so with that disabling rfkill you should be able to use your
> > wireless. Can you still not use wireless even when rfkill reports
> > "RFKILL event: idx 6 type 1 op X soft 0 hard 0" ?
> 
> No.
> 
> I can use wifi if rfkill reports "RFKILL event: idx 6 type 1 op X soft 0 hard
> 0".
> 
> My problem is, that since 2.6.31-rcX Fn+F5 toggles soft rfkill state. It did
> not happen in 2.6.30 and earlier. In that case, Fn+F5 triggered an acpi event
> (key press). Now, it triggers acpi eveny *and* touches soft rfkill of WIFI.
> I like the previous behavior, i.e., don't touch anything, just report acpi
> event.

I do not know why your Lenovo T61 gets wifi software rfkill when you
press Fn-F5 and mine does not. I am adding Henrique and hope he can tell
us what is going on. 

Reinette


