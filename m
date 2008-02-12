Return-Path: <linux-kernel-owner+w=401wt.eu-S1762389AbYBLKpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762389AbYBLKpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 05:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbYBLKpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 05:45:20 -0500
Received: from smtp.nokia.com ([192.100.122.230]:37221 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbYBLKpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 05:45:18 -0500
Date: Tue, 12 Feb 2008 12:45:15 -0500
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext David Brownell <david-b@pacbell.net>
Cc: Felipe Balbi <felipe.balbi@nokia.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, me@felipebalbi.com
Subject: Re: [PATCH] USB: OTG: Fix weirdnesses on enumerating partial otg
	devices
Message-ID: <20080212174515.GU4769@gandalf.research.nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1202835603-10663-1-git-send-email-felipe.balbi@nokia.com> <200802120228.54123.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802120228.54123.david-b@pacbell.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 12 Feb 2008 10:44:42.0236 (UTC) FILETIME=[46390BC0:01C86D64]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 02:28:53AM -0800, David Brownell wrote:
> On Tuesday 12 February 2008, Felipe Balbi wrote:
> > Some devices claim
> > to be b_host even though they have an a_connector attached to it.
> 
> Why not just fix that bug?  Remember that's Linux code.

The device claiming to be b_host is not linux based. In any case this
is_b_host check won't do nothing here as we should check is
SetFeature(b_hnp_enbable) has been succesfull.

A device in b_host state is not enough for allowing hnp to happen.
Remember some devices doesn't support hnp in B roles, only a_hnp_support
is mandatory.

-- 
	- Balbi
