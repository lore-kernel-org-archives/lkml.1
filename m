Return-Path: <linux-kernel-owner+w=401wt.eu-S1762994AbYBUXzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762994AbYBUXzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936415AbYBUXxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:53:45 -0500
Received: from testure.choralone.org ([194.9.77.134]:43850 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936409AbYBUXxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:53:42 -0500
Date: Thu, 21 Feb 2008 18:53:29 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Yi Yang <yi.y.yang@intel.com>, Alan Stern <stern@rowland.harvard.edu>,
       Frans Pop <elendil@planet.nl>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 03/11] cpufreq: fix kobject reference count handling
Message-ID: <20080221235329.GA28514@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
	Balaji Rao <balajirrao@gmail.com>, Yi Yang <yi.y.yang@intel.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Frans Pop <elendil@planet.nl>, Yinghai Lu <yhlu.kernel@gmail.com>,
	Ingo Molnar <mingo@elte.hu>
References: <20080221234649.GB7128@kroah.com> <1203637687-7273-3-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203637687-7273-3-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 03:47:59PM -0800, Greg Kroah-Hartman wrote:
 > From: Balaji Rao <balajirrao@gmail.com>
 > 
 > The cpufreq core should not take an extra kobject reference count for no
 > reason, and then refuse to release it.  This has been reported as
 > keeping machines from properly powering down all the way.
 > 
 > 
 > Signed-off-by: Balaji Rao <balajirrao@gmail.com>
 > Cc: Dave Jones <davej@codemonkey.org.uk>
 > Cc: Yi Yang <yi.y.yang@intel.com>
 > Cc: Alan Stern <stern@rowland.harvard.edu>
 > Cc: Frans Pop <elendil@planet.nl>
 > Cc: Yinghai Lu <yhlu.kernel@gmail.com>
 > Cc: Ingo Molnar <mingo@elte.hu>
 > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

ACK. This needs to go in soon, so I can stop hearing about it :-)

	Dave

-- 
http://www.codemonkey.org.uk
