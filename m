Return-Path: <linux-kernel-owner+w=401wt.eu-S1762989AbYEHPDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762989AbYEHPDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 11:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764562AbYEHPCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 11:02:42 -0400
Received: from main.gmane.org ([80.91.229.2]:41458 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764347AbYEHPCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 11:02:40 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: linux-next does not find root partition on PATA ICH5
Date: Thu, 08 May 2008 16:02:25 +0100
Message-ID: <fvv4m2$mp1$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: KNode/0.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to boot a linux-next kernel (git cloned today) never seems to find
the root partition. Putting the PATA drivers and ext3 components into the
kernel image rather than modules makes no difference. Near enough the same
config boots on 2.6.26rc1 (git pulled today).

Apologies for posting this to the main kernel list - the linux-next list
doesn't yet appear to be fully on GMANE (
http://dir.gmane.org/gmane.linux.kernel.next ) or Google Groups...

lspci for the IDE interface:
00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE
Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801EB (ICH5) SATA Controller (rev
02)

The kernel config used is on
http://sucs.org/~sits/test/kernel-config-20080508 .

-- 
Sitsofe

