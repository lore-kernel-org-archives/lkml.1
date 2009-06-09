Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbZFIUDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbZFIUDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 16:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbZFIUDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 16:03:48 -0400
Received: from mail.electro-mechanical.com ([216.184.71.30]:36856 "EHLO
	mail.electro-mechanical.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752303AbZFIUDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 16:03:47 -0400
X-Greylist: delayed 769 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Jun 2009 16:03:47 EDT
Date: Tue, 9 Jun 2009 15:51:00 -0400
From: William Thompson <wt@electro-mechanical.com>
To: linux-kernel@vger.kernel.org
Subject: 3com 3crxjk10075 with ath5k driver
Message-ID: <20090609195100.GY19203@electro-mechanical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This card has the "xjack" antennae which is supposed to disable the radio (I
thought it was in hardware, but it's not) when it is not extended.  The
madwifi driver (Last time I actually used this card with it) did disable the
radio (Or refused packets, not sure which).

The kernel ath5k driver (last tested 2.6.29.4) will work regardless if the
antannae is in or out.
