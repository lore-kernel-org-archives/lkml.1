Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbYFUK61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbYFUK61 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 06:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbYFUK6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 06:58:17 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:31623 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbYFUK6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 06:58:16 -0400
Date: Sat, 21 Jun 2008 01:44:40 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Ben Nizette <bn@niasdigital.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>, Felix Fietkau <nbd@openwrt.org>,
       Al Viro <viro@ftp.linux.org.uk>, "H. Peter Anvin" <hpa@kernel.org>
Subject: Re: [RFC PATCHES] Re: Is configfs the right solution for
	configuration based fs?
Message-ID: <20080621084440.GA25489@ca-server1.us.oracle.com>
Mail-Followup-To: Ben Nizette <bn@niasdigital.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux kernel <linux-kernel@vger.kernel.org>,
	Greg KH <greg@kroah.com>, Satyam Sharma <ssatyam@cse.iitk.ac.in>,
	Felix Fietkau <nbd@openwrt.org>, Al Viro <viro@ftp.linux.org.uk>,
	"H. Peter Anvin" <hpa@kernel.org>
References: <1213002187.698.62.camel@johannes.berg> <1213056772.4089.42.camel@moss.renham> <20080619024804.GA29765@mail.oracle.com> <1213942750.2336.43.camel@moss.renham> <20080620065253.GA14238@ca-server1.us.oracle.com> <1213953776.2336.75.camel@moss.renham> <20080620213708.GC21416@mail.oracle.com> <1214010229.2336.88.camel@moss.renham> <20080621020201.GH21416@mail.oracle.com> <1214035422.2336.121.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214035422.2336.121.camel@moss.renham>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2008 at 06:03:42PM +1000, Ben Nizette wrote:
> In the kobject/kset case the separation makes sense as kobjects are
> embedded in things all over the kernel controlling things like ref
> counting, device model glue, hotplug info as well as the sysfs
> representation.  The config_item doesn't have any responsibilities
> outside of the configfs representation (does it?) so the analogy isn't
> 100%.  Though of course the item/group split makes sense if there are
> grander plans for the config_item in the future.

	The config_item is indeed embedded in whatever struct it maps
too.  eg, the ocfs2 nodemanager can have a couple hundred nodes, and
that's one config_item per.  The fs/dlm stuff can have even more nodes.

Joel

-- 

Life's Little Instruction Book #222

	"Think twice before burdening a friend with a secret."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
