Return-Path: <linux-kernel-owner+w=401wt.eu-S1751731AbXB1HAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbXB1HAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 02:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbXB1HAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 02:00:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbXB1HAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 02:00:14 -0500
Date: Wed, 28 Feb 2007 01:59:32 -0500
From: Dave Jones <davej@redhat.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       linux-acpi@vger.kernel.org, Adam Belay <abelay@novell.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "Brown, Len" <len.brown@intel.com>
Subject: Re: [PATCH 1/3]cpuidle take2: Core cpuidle infrastructure
Message-ID: <20070228065932.GA23678@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, linux-acpi@vger.kernel.org,
	Adam Belay <abelay@novell.com>,
	"Li, Shaohua" <shaohua.li@intel.com>,
	"Brown, Len" <len.brown@intel.com>
References: <20070227164427.GB2223@redhat.com> <EB12A50964762B4D8111D55B764A845401540255@scsmsx413.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EB12A50964762B4D8111D55B764A845401540255@scsmsx413.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 08:47:55PM -0800, Pallipadi, Venkatesh wrote:

 > >I played with this a little, and got puzzled.
 > >My quad core box used exactly the same amount of power whether the
 > >'ladder' governer was loaded & in use or not.  In both situations
 > >it was exactly the same as a vanilla 2.6.20
 > >
 > >I'd have expected it to use more until I loaded up 'ladder' to bring it
 > >on par featurewise with 2.6.20.  What did I miss?
 > 
 > Quad core what platform?

Glenwood

 > How many C-states are supported in this platform?

Garg, only C1.  That explains a lot.

 > Current ladder is mostly like Policy embedded in ACPI today. But, Adam
 > has
 > been working on different policies that we want to experiment with as we
 > go along.

ok.

		Dave


-- 
http://www.codemonkey.org.uk
