Return-Path: <linux-kernel-owner+w=401wt.eu-S1759528AbXK1Jxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528AbXK1Jxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 04:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbXK1Jxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 04:53:32 -0500
Received: from web36715.mail.mud.yahoo.com ([209.191.85.49]:43894 "HELO
	web36715.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755548AbXK1Jxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 04:53:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=lbZT2oKMsKjDbBdvc6yO4vjuBJCxsYfATSF68m7bCPUyPPMsV3/riPofbNMc8mb+PGmk7wLL3tKi0TwT2UwYLDEHKeGipwQ4u4G8rTiSE08krCamWQF6JyaunZ+fqVtczumShNoIS3SR6+4wrn8BO+B6sJ3xjv+Z1nGUTdb1jwA=;
X-YMail-OSG: Xe_lC.UVM1mRuXHrOmrTTHssykPP0YuceVY8vC95b1wPOAmhtPqLq.yAkanzGO8nOivQs.pg3fuTbYUOzt8WC43k3d9JUt4py8ab7j2LoLh3Z.UG1Rk-
Date: Wed, 28 Nov 2007 01:53:31 -0800 (PST)
From: murtuja bharmal <murtuja_bharmal@yahoo.com>
Subject: Re: Linux 2.6 kernel module compilation without using KBUILD
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild <linux-kbuild@vger.kernel.org>
In-Reply-To: <20071128090046.GA15067@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <180651.51647.qm@web36715.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Sam Ravnborg <sam@ravnborg.org> wrote:

> On Wed, Nov 28, 2007 at 12:09:51AM -0800, murtuja
> bharmal wrote:
> > Hello All,
> >    
> > I want to compile external linux kernel module
> without
> > using KBUILD.
> ...
> > Do we have any document which describe how to make
> > kernel module without using KBUILD.
> 
> No.
> Becasue building kernel modules without using kbuild
> is highly 
> discouraged and vulnerable for all sort of config
> related issues.
> As a simple example the module may become unuseable
> if just one
> change is made to the configuration because this
> changes
> the parameters passed to gcc which again affects the
> code
> being built.
> 
> Can you try to enlighting why you want to avoid
> kbuild.
> If you have a specific problem then maybe kbuild
> already can
> do what you need.
> 
> 	Sam
> -
> To unsubscribe from this list: send the line
> "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
Hello Sam,

My intention is  to just understand whole  
process of making kernel module.
Actually I am working on one project in which I have
to port lots of 2.4 kernel module in 2.6 kernel.
So I thought lets first try to understand, what is
going behind KBUILD.
I also gone through  linux/Documentation/kbuild/ but
didn't get very much information.
Even after running it on Verbose Mode, I am not very
much clear.

Thanks
Murtuja Bharmal
    


      ____________________________________________________________________________________
Get easy, one-click access to your favorites. 
Make Yahoo! your homepage.
http://www.yahoo.com/r/hs 
