Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbZCNNhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbZCNNhW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 09:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbZCNNhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 09:37:08 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:40917 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbZCNNhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 09:37:07 -0400
Date: Sat, 14 Mar 2009 13:37:04 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
       dri-devel@lists.sourceforge.net
Subject: Re: 2.6.29-rc breaks STD using Intel 945
Message-ID: <20090314133704.GA21948@silver.sucs.org>
References: <200903042020.57671.eike-kernel@sf-tec.de> <20090305125529.GB16693@silver.sucs.org> <200903081902.23998.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903081902.23998.eike-kernel@sf-tec.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 08, 2009 at 07:02:17PM +0100, Rolf Eike Beer wrote:
> Sitsofe Wheeler wrote:
> > On Wed, Mar 04, 2009 at 08:20:56PM +0100, Rolf Eike Beer wrote:
> > > I tested several snapshots post 2.6.28 and all of them show one severe
> > > problem: resume from disk is not always successful. Only about 50% of the
> > > resume attempts work, in the other cases I just get a completely black
> > > screen, can't switch to text console or anything. What I often get is a
> > > line like this in the logs directly before suspend:
> >
> > Does this happen when X hasn't been started and you suspend to disk then
> > resume?
> 
> I tested several times without X, with X running only in backgroud (i.e. me 
> initiating the suspend from console) and from xdm only. Never it froze. That 
> leads me to the conclusion that it is probably related to composite. I'm 

Hmm. Does switching to and then back from a virtual terminal also break?

-- 
Sitsofe | http://sucs.org/~sits/
