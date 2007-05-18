Return-Path: <linux-kernel-owner+w=401wt.eu-S1762859AbXERTpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762859AbXERTpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 15:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759958AbXERTo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 15:44:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754964AbXERTo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 15:44:57 -0400
Date: Fri, 18 May 2007 15:44:44 -0400
From: Dave Jones <davej@redhat.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Henry Su <henry.su@amd.com>, alan@lxorguk.ukuu.org.uk, greg@kroah.com,
       bzolnier@gmail.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, xiaosuzi520@hotmail.com
Subject: Re: [patch] Add the device IDs for AMD/ATI SB700
Message-ID: <20070518194444.GA27229@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jeff Garzik <jeff@garzik.org>, Henry Su <henry.su@amd.com>,
	alan@lxorguk.ukuu.org.uk, greg@kroah.com, bzolnier@gmail.com,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
	xiaosuzi520@hotmail.com
References: <FFECF24D2A7F6D418B9511AF6F3586020197F6A6@shacnexch2.atitech.com> <4641C066.8080100@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4641C066.8080100@garzik.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 08:36:54AM -0400, Jeff Garzik wrote:
 > Henry Su wrote:
 > > From: henry.su@amd.com
 > > Adding the device ID for AMD/ATI SB700.
 > > Signed-off-by:henry su <henry.su@amd.com>
 > 
 > Time to train new people...
 > 
 > You need to split up your patches:
 > * send I2C and PCI quirk patches to GregKH
 > * send drivers/ide/* stuff to Bart
 > * send drivers/ata/* patches to me

Additionally, these patches seem to be hurrendously MIME damaged.
patch(1) sees this..

diff -Nur linux-2.6.21.1.orig/include/linux/pci+AF8-ids.h linux-2.6.21.1/include/linux/pci+AF8-ids.h
--- linux-2.6.21.1.orig/include/linux/pci+AF8-ids.h 2007-05-16 13:28:54.405386000 +-0800
+-+-+- linux-2.6.21.1/include/linux/pci+AF8-ids.h      2007-05-16 13:45:29.936636000 +-0800
+AEAAQA- -371,6 +-371,9 +AEAAQA-
+ACM-define PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP600+AF8-SRAID 0x4381
+ACM-define PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP600+AF8-SMBUS 0x4385
+ACM-define PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP600+AF8-IDE   0x438c
+-+ACM-define PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP700+AF8-SATA  0x4390
+-+ACM-define PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP700+AF8-SMBUS 0x4395
+-+ACM-define PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP700+AF8-IDE   0x439c

	Dave

-- 
http://www.codemonkey.org.uk
