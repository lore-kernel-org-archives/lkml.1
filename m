Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405Ab0AGScR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab0AGScR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 13:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165Ab0AGScQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 13:32:16 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:41725 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab0AGScP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 13:32:15 -0500
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jan 2010 13:32:14 EST
Date: Thu, 7 Jan 2010 19:25:53 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ping Cheng <pingc@wacom.com>
Subject: [PATCH 0/7] Input: wacom - Setup features via driver info
Message-ID: <20100107182553.GA11236@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ping Cheng <pingc@wacom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset moves the feature info into the driver info of the usb
device ids.  The wacom driver always needs this info to setup the
device.

Currently the driver uses two synchronized arrays with the standard ids
and the features.  It calculates the index into the features array by
hand and does not check for overflow.  With the ability to add new ids
to the driver, I can instruct the driver to access non-existant features
entries and produce crashes in the uevent core.

Bastian

-- 
I'm a soldier, not a diplomat.  I can only tell the truth.
		-- Kirk, "Errand of Mercy", stardate 3198.9
