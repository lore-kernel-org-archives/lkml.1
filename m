Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbZAJCQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbZAJCQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 21:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbZAJCQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 21:16:48 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:37316 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbZAJCQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 21:16:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=iwx4t6S7IgAHJHA+gTrD6XUt/tOo5uv2mrPTLerMsOmfvElporCZOOUOfilKgcJkOH
         SIlsw48pVMqze5+2lPx1sJfikq/IAGbO5Z+L4AYcUwJDK/CPbqqbWjNWmzOwaWyLXYXC
         bhPfrmrhZPgMaO2/oLa5wXJNA262yI0tCcnXw=
Date: Sat, 10 Jan 2009 05:16:41 +0300
From: Alexander Beregalov <a.beregalov@gmail.com>
To: akorolev@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: mtd/lpddr/qinfo_probe.c needs lpddr_cmds to be compiled
Message-ID: <20090110021641.GA26951@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/built-in.o: In function `lpddr_probe':
drivers/mtd/lpddr/qinfo_probe.c:215:
undefined reference to `lpddr_cmdset'

# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_QINFO_PROBE=y
