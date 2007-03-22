Return-Path: <linux-kernel-owner+w=401wt.eu-S965716AbXCVFPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965716AbXCVFPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 01:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965737AbXCVFPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 01:15:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965716AbXCVFP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 01:15:29 -0400
Date: Thu, 22 Mar 2007 01:15:25 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: sam@ravnborg.org
Subject: $CHECK can't be overridden
Message-ID: <20070322051525.GD17159@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, sam@ravnborg.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

make help implies that supplying $CHECK on the command line
should override sparse as the checker used when building with C=1
Yet, this doesn't seem to be the case.

This would be useful for cases where for eg, sparse isn't in
the $PATH, allowing an explicit path to the executable to be
passed in automated build environments.

	Dave

-- 
http://www.codemonkey.org.uk
