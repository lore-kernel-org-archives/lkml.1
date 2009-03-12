Return-Path: <linux-kernel-owner+w=401wt.eu-S1753696AbZCLIBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbZCLIBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 04:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbZCLIAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 04:00:55 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:42783 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbZCLIAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 04:00:55 -0400
Message-ID: <49B8C12B.1040508@davidnewall.com>
Date: Thu, 12 Mar 2009 18:30:43 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /dev/time for Linux, inspired by Plan 9
References: <20090311200411.WPUP4619.eastrmmtao102.cox.net@eastrmimpo02.cox.net> <20090311220700.GA16368@nostromo.devel.redhat.com>
In-Reply-To: <20090311220700.GA16368@nostromo.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Nottingham wrote:
> Given the general array of current interfaces in the kernel, isn't
> read/write of textual parameters better suited to sysfs or procfs
> than a character device?

Procfs and Sysfs are used to control devices.  Dev is used to access
them.  Dev is the right place to fetch and set the time; having a text
interface is beside the point.
