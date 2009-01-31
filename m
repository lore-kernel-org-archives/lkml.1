Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbZAaSNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbZAaSNx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 13:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbZAaSNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 13:13:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54019 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbZAaSNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 13:13:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Q: state of pci express hotplug
Date: Sat, 31 Jan 2009 19:13:00 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       Alex Chiang <achiang@hp.com>, djwong@us.ibm.com,
       Trent Piepho <xyzzy@speakeasy.org>, linux-kernel@vger.kernel.org
References: <m1fxj06js8.fsf@fess.ebiederm.org>
In-Reply-To: <m1fxj06js8.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901311913.00752.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Saturday 31 January 2009, Eric W. Biederman wrote:
> 
> Trying to use the current pciehp code, on real hardware in an 
> interesting topology (more later) I'm not finding it very satisfactory
> at all.  I am up to at least three show stopper bugs and the code
> is not doing what I really need it to do, so I am looking at a significant
> rewrite patch effort to make this code usable.
> 
> Am I unique in thinking there is a lot that needs to be done?
> Is there current work in progress to make the pci hotplug work better?
> 
> I would like to avoid duplicate work if I can.

I've recently send some fixes against the PCIe port driver which is used by
PCIe hotplug.  In particular, there's a fix that should make the thing work
with MSI-X.

Are your fixes specific to the hotplug driver or do they also affect the PCIe
port driver?

Rafael
