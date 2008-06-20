Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbYFTG50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbYFTG50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 02:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYFTG5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 02:57:15 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:44970 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbYFTG5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 02:57:14 -0400
Date: Thu, 19 Jun 2008 23:52:53 -0700
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
Message-ID: <20080620065253.GA14238@ca-server1.us.oracle.com>
Mail-Followup-To: Ben Nizette <bn@niasdigital.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux kernel <linux-kernel@vger.kernel.org>,
	Greg KH <greg@kroah.com>, Satyam Sharma <ssatyam@cse.iitk.ac.in>,
	Felix Fietkau <nbd@openwrt.org>, Al Viro <viro@ftp.linux.org.uk>,
	"H. Peter Anvin" <hpa@kernel.org>
References: <43e72e890806081425h4e785800nc618fc1985f9809f@mail.gmail.com> <1213002187.698.62.camel@johannes.berg> <1213056772.4089.42.camel@moss.renham> <20080619024804.GA29765@mail.oracle.com> <1213942750.2336.43.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213942750.2336.43.camel@moss.renham>
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

On Fri, Jun 20, 2008 at 04:19:10PM +1000, Ben Nizette wrote:
> Looks great, thx :-).  I'll convert some of my stuff over to this
> interface and see how it flies in the real world.

	Excellent.  What is your stuff, btw?  Got code?  Love to see it.

> ISTR when I did this I kept the old semantics and used ERR_PTR and
> friends if things went pear-shaped.  Given the small number of in-tree
> users needing to be moved over, a more intrusive change for the sake of
> a cleaner API like you've done is probably a good thing anyway :-)

	Yeah, I like this better than ERR_PTR.
	If you like the macros, I'll try to make the next merge window
as well.  So let me know.

joel

-- 

"I almost ran over an angel
 He had a nice big fat cigar.
 'In a sense,' he said, 'You're alone here
 So if you jump, you'd best jump far.'"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
