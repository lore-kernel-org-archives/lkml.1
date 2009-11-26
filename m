Return-Path: <linux-kernel-owner+w=401wt.eu-S1759453AbZKZLpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453AbZKZLpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 06:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbZKZLpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 06:45:34 -0500
Received: from smtp.nokia.com ([192.100.122.230]:45546 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbZKZLpd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 06:45:33 -0500
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: ext Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: linux-next: workqueues tree build failure
Date: Thu, 26 Nov 2009 13:44:31 +0200
User-Agent: KMail/1.12.3 (Linux/2.6.31-gentoo-r4; KDE/4.3.3; i686; ; )
Cc: ext Tejun Heo <tj@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
References: <20091126190050.3f9d7fef.sfr@canb.auug.org.au> <200911261131.15155.peter.ujfalusi@nokia.com> <20091126101859.GA27562@rakim.wolfsonmicro.main>
In-Reply-To: <20091126101859.GA27562@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200911261344.32051.peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 26 Nov 2009 11:44:37.0602 (UTC) FILETIME=[D4F91C20:01CA6E8D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 November 2009 12:18:59 ext Mark Brown wrote:
> On Thu, Nov 26, 2009 at 11:31:15AM +0200, Peter Ujfalusi wrote:
> > For a quick fix, I can convert the tlv320dac33 driver to use this, and
> > revisit later, if it does not fulfill the timing requirements for the HW.
> 
> If there are problems then creating a dedicated thread you can wake
> would probably do the job.

For now I'm going to change the create_rt_workqueue to 
create_singlethread_workqueue, that is available at the wq.git of kernel.org.

If it is not sufficient, than I might use dedicated thread, which I woke up, but 
I would like to keep that as a backup plan, since it needs more work ;)

I'll send the patch in a few minutes.

-- 
Péter
