Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723Ab0AFKNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab0AFKNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 05:13:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672Ab0AFKNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 05:13:13 -0500
Received: from smtp.nokia.com ([192.100.105.134]:41413 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab0AFKNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 05:13:12 -0500
Subject: sections mismatch detection
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jan 2010 12:11:23 +0200
Message-Id: <1262772683.4263.147.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 Jan 2010 10:11:27.0364 (UTC) FILETIME=[9BDE3C40:01CA8EB8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wonder is it good time to enable DEBUG_SECTION_MISMATCH by default
now? I mean, remove the following from lib/Kconfig.debug:

config DEBUG_SECTION_MISMATCH
        bool "Enable full Section mismatch analysis"
        depends on UNDEFINED
        # This option is on purpose disabled for now.
        # It will be enabled when we are down to a resonable number
        # of section mismatch warnings (< 10 for an allyesconfig build)

Just spotted this, and decided to remind.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

