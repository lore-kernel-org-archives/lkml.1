Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454AbZFCOk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbZFCOk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZFCOkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:40:20 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59834 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954AbZFCOkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:40:19 -0400
Date: Wed, 3 Jun 2009 22:39:44 +0800
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Robert Berger <robert.berger@reliableembeddedsystems.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: http://patchwork.kernel.org/patch/26483/ broke my system boot
Message-ID: <20090603143944.GF29326@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After spending some time figuring out why my system failed to reboot,
checking config options, kernel version, modules installed. I figured
out that the patch in http://patchwork.kernel.org/patch/26483/ broke
the system boot on the latest mmotm. Reverting it helped my system
call depmod and hence boot.

The patch is really unhelpful, since the changelog is completely
empty. Sigh!

-- 
	Balbir
