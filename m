Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbYBDNFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbYBDNFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbYBDNEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:04:33 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:46977 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbYBDNE3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:04:29 -0500
From: Jan-Bernd Themann <ossthema@de.ibm.com>
Subject: [PATCH 0/2] ehea: kdump & memory remove support
Date: Mon, 4 Feb 2008 14:04:25 +0100
User-Agent: KMail/1.8.2
MIME-Version: 1.0
Content-Disposition: inline
To: Jeff Garzik <jeff@garzik.org>
Cc: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ppc" <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200802041404.26138.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for kdump and hotplug memory remove
to the eHEA driver. 

The "memory remove" patch depends on the following patch that
has been posted a few days ago. That patch exports the symbols
 - register_memory_notifier()
 - unregister_memory_notifier()

http://lkml.org/lkml/2008/2/1/293

Regards,
Jan-Bernd
