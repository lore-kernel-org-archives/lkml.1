Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbYHSKxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbYHSKxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 06:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYHSKxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 06:53:00 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:45316 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbYHSKw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 06:52:59 -0400
In-Reply-To: <18602.18568.338552.482669@cargo.ozlabs.ibm.com>
References: <200808051630.19619.fenkes@de.ibm.com> <18602.18568.338552.482669@cargo.ozlabs.ibm.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Alexander Schmidt1 <ALEXSCHM@de.ibm.com>,
       Christoph Raisch <RAISCH@de.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>, Olaf Hering <olaf@aepfle.de>,
       Paul Mackerras <pmac@au1.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH] ibmebus/of_platform: Move "name" sysfs attribute into generic
 OF devices
X-KeepSent: D6515867:CFE29C04-C12574AA:003B8D55;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.0.1 HF105 April 10, 2008
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OFD6515867.CFE29C04-ONC12574AA.003B8D55-C12574AA.003BB443@de.ibm.com>
Date: Tue, 19 Aug 2008 12:52:07 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 8.0.1|February 07, 2008) at
 19/08/2008 12:52:08,
	Serialize complete at 19/08/2008 12:52:08
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras <paulus@samba.org> wrote on 19.08.2008 06:14:00:
 
> > Recent of_platform changes made of_bus_type_init() overwrite the bus 
type's
> > .dev_attrs list, so move ibmebus' "name" attribute (which is needed by 
eHCA
> > userspace support) into generic OF device code. Tested on POWER.
> 
> Is this a bugfix that is needed for 2.6.27?

Yes, definitely. The eHCA userspace driver relies on the name attribute to 
check for valid adapters (it checks that the name is "lhca"), so with the 
name attribute gone, eHCA userspace will cease to work.

Regards,
  Joachim
