Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbXJ2WpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbXJ2WpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbXJ2Wo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:44:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393AbXJ2Woz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:44:55 -0400
Date: Mon, 29 Oct 2007 18:44:50 -0400
From: Dave Jones <davej@redhat.com>
To: sam@ravnborg.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Domen Puncer <domen.puncer@telargo.com>
Subject: FEC kconfig warnings.
Message-ID: <20071029224450.GA29131@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, sam@ravnborg.org,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Domen Puncer <domen.puncer@telargo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

make defconfig on x86-64 prints this for me ..

drivers/net/Kconfig:1887:warning: 'select' used by config symbol 'FEC_MPC52xx' refers to undefined symbol 'PPC_BESTCOMM'
drivers/net/Kconfig:1888:warning: 'select' used by config symbol 'FEC_MPC52xx' refers to undefined symbol 'PPC_BESTCOMM_FEC'

I'm not sure why those selects are even being evaluated, as both those
options have 'depends on PPC_MPC52xx'

	Dave

-- 
http://www.codemonkey.org.uk
