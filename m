Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbYICVdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbYICVdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 17:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYICVdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 17:33:10 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:60505 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752581AbYICVdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 17:33:09 -0400
X-Sasl-enc: 5kZWON2Z1A9EWujpxTYd/ESgN/aIn5KuKs/H0G+k8n2t 1220477587
Date: Wed, 3 Sep 2008 18:32:58 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Daniel Barkalow <barkalow@iabervon.org>,
       linux-kernel@vger.kernel.org,
       Christopher Desjardins <cddesjardins@gmail.com>
Subject: Re: Lenovo 3000 N100 i8042 problems
Message-ID: <20080903213258.GC14620@khazad-dum.debian.net>
References: <alpine.LNX.1.00.0808240148580.19665@iabervon.org> <Pine.LNX.4.64.0809020120130.29111@twin.jikos.cz> <alpine.LNX.1.00.0809012014280.19665@iabervon.org> <alpine.LNX.1.10.0809021121410.23448@jikos.suse.cz> <20080902083940.ZZRA012@mailhub.coreip.homeip.net> <alpine.LNX.1.10.0809031349081.23448@jikos.suse.cz> <20080903101947.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080903101947.ZZRA012@mailhub.coreip.homeip.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Sep 2008, Dmitry Torokhov wrote:
> On Wed, Sep 03, 2008 at 01:50:35PM +0200, Jiri Kosina wrote:
> > On Tue, 2 Sep 2008, Dmitry Torokhov wrote:
> > > I guess we could use System's product name to differentiate between 
> > > Cristopher's and Daniel's boards. Although I must admit it is the very 
> > > first time when I see a box that behaves better with active mux. DOes 
> > > Vista use active mux nowadays? Because if it is not then I bet there is 
> > > (or shortly will be) a BIOS update fixing legacy mode on Daniel's box.
> > 
> > I guess so, yes.
> > 
> > On the other hand, this might also be viewed as regression (we made 
> > Daniel's hardware behave worse with recent kernel than it did before), so 
> > I think we still would like to have this fixed. What about the patch 
> > below, adding the match on System's product name, as you suggested? 
> > Thanks.
> > 
> 
> I agree. Daniel, could you please try the patch to make sure it
> restores the previous behavior for you and I will push it through.

I fell I need to warn you guys that you are likely breaking machines that
match that DMI info but have a newer BIOS, unless they use different BIOSes
(not enough data without a full dmidecode output from the other machine).

But I really don't care either way, since this is not about ThinkPads :)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
