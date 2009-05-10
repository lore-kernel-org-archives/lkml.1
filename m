Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbZEJMsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbZEJMsD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 08:48:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbZEJMrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 08:47:49 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:60941 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbZEJMrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 08:47:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JUijqlmcjvLlU52BYcRNF/nsPfvR+sMIs47h8ph4wTZJrkWNUKDFgTi+RVtiBoPpwn
         9G+Qrw86/1WfJBwKNicMnr9hnaqQi8ESGtkg9M7lSObS3hpwM/BJ1s1fID+q/CvqP6gF
         UBUikKQU2G2Gy1l+ujCFYtPL4fBGju3knAQNo=
Date: Sun, 10 May 2009 14:46:41 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: "Alexander V. Lukyanov" <lav@netis.ru>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.29.1: unregister_netdevice problem
Message-ID: <20090510124641.GA2978@ami.dom.local>
References: <20090422055735.GA4334@night.netis.ru> <20090427054103.GA27529@night.netis.ru> <20090428125755.GA5242@night.netis.ru> <49F76BF6.4040709@gmail.com> <20090429054510.GA8267@night.netis.ru> <20090429090809.GA2995@ami.dom.local> <20090508062640.GA4555@night.netis.ru> <20090508104628.GA6287@ff.dom.local> <20090510073559.GA8929@night.netis.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090510073559.GA8929@night.netis.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 10, 2009 at 11:35:59AM +0400, Alexander V. Lukyanov wrote:
> On Fri, May 08, 2009 at 10:46:28AM +0000, Jarek Poplawski wrote:
> > I can't see anything suspicious for now, except these UDP and TCP
> > warnings. Did you see similar messages with 2.6.27? Btw., could this
> 
> Yes. Such messages show up with any kernel version.
> 
> > eth0.987 be "connected" with any of this traffic? (IP# ?)
> 
> No, eth0.987 is only used for traffic output.
> 
> BTW, it seems that only actively used vlan interfaces have the problem
> (even when the traffic stops). Other vlan interfaces with little traffic
> can be removed with no problems.

OK, I'll try to look around this, but how about trying 2.6.28.10 in
the meantime? It could limit "a bit" the number of places/lines.

Jarek P.
