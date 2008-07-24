Return-Path: <linux-kernel-owner+w=401wt.eu-S1751816AbYGXBaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbYGXBaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 21:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbYGXB37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 21:29:59 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:60211 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750836AbYGXB37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 21:29:59 -0400
Date: Wed, 23 Jul 2008 21:29:57 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: linux-kernel@vger.kernel.org
Subject: 2.2.6-git9, ath_pci and suspend
Message-ID: <20080724012957.GA23873@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   I have been having issues with the madwifi svn drivers since
I upgraded to the 2.6.26 kernel series. The problem I've been seeing
is that the connection sometime becomes disrupted and when the 
NetworkManager attempts to reconnect it always asks for the WPA2
secret but never successfully reconnects. This issue appears to be
common and the solution that works here is to create a suspend_modules
file in /etc/pm/config.d containing the line...

SUSPEND_MODULES='ath_pci'

This change has fixed the issue here on my MacBook Pro with Fedora 9 x86_64.
Does anyone know what changed with the suspend code in 2.6.26 that could
be causing this problem.
               Jack
