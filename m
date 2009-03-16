Return-Path: <linux-kernel-owner+w=401wt.eu-S1760481AbZCPRQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760481AbZCPRQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 13:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756025AbZCPRQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:16:15 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:57977 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107AbZCPRQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:16:14 -0400
Date: Mon, 16 Mar 2009 17:16:10 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Frank Seidel <fseidel@suse.de>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>,
       LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
       dri-devel@lists.sourceforge.net
Subject: Re: 2.6.29-rc breaks STD using Intel 945
Message-ID: <20090316171610.GA10814@silver.sucs.org>
References: <200903042020.57671.eike-kernel@sf-tec.de> <20090305125529.GB16693@silver.sucs.org> <200903081902.23998.eike-kernel@sf-tec.de> <20090314133704.GA21948@silver.sucs.org> <49BE4E00.9000505@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BE4E00.9000505@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 02:02:56PM +0100, Frank Seidel wrote:
> Sitsofe Wheeler wrote:
> > Hmm. Does switching to and then back from a virtual terminal also break?
> 
> I think i have the same problem and yes, switching to and back from vt
> also breaks X.
> I opened a bug here: https://bugzilla.novell.com/show_bug.cgi?id=485537
> 
> For me it currently helps to disable dri which makes my system stable
> again.

The reason I asked is because I am seeing a problem/regression
with VT switching but only when AIGLX is on:
http://marc.info/?l=linux-kernel&m=123523074304955&w=4 ,
http://marc.info/?l=dri-devel&m=123666881014615&w=4 and
http://bugzilla.kernel.org/show_bug.cgi?id=12765 .

The above may or may not be what Rolf is seeing (but if it is it would
be good to know so they can all be collected together)...

-- 
Sitsofe | http://sucs.org/~sits/
