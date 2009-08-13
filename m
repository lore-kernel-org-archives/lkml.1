Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbZHMVDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbZHMVDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 17:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756281AbZHMVDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 17:03:09 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:57864 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221AbZHMVDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 17:03:08 -0400
Date: Fri, 14 Aug 2009 06:03:08 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH update 2x] PM: Introduce core framework for run-time PM of I/O devices (rev. 16)
Message-ID: <20090813210308.GA9570@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Alan Stern <stern@rowland.harvard.edu>,
	Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>,
	Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
References: <200908081625.57333.rjw@sisk.pl> <200908092313.05541.rjw@sisk.pl> <200908132256.42941.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908132256.42941.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 10:56:42PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM: Introduce core framework for run-time PM of I/O devices (rev. 16)
> 
> Introduce a core framework for run-time power management of I/O
> devices.  Add device run-time PM fields to 'struct dev_pm_info'
> and device run-time PM callbacks to 'struct dev_pm_ops'.  Introduce
> a run-time PM workqueue and define some device run-time PM helper
> functions at the core level.  Document all these things.
> 
> Special thanks to Alan Stern for his help with the design and
> multiple detailed reviews of the pereceding versions of this patch
> and to Magnus Damm for testing feedback.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

If there are no more outstanding issues with this, any chance of having
this rolled in to a topic branch along with Magnus's platform bus
support? It would be nice if these could spend some time in -next,
especially as it seems there are no longer any glaring issues with the
patch series.
