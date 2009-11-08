Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbZKHRzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbZKHRzm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 12:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbZKHRzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 12:55:41 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:53848 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbZKHRzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 12:55:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Mp3fk06/jxTtTV48FzNy4bSzZMqA8z/42kk5sPi1z+ACjepYCSDpDGSlk8HvuKmjrr
         oATVdsdMMme7qUQOZAXQxb1l+dMTsAp+XJrx/ZYh9yUq/Pz58RdO98XbK2zQOxxCa0uu
         ic+zjgp5ceZVWo6BVHK2m5Gdf5GSYEokqVGdA=
Date: Sun, 8 Nov 2009 21:27:04 +0330
From: Ali Gholami Rudi <ali@rudi.ir>
To: Patrick Ohly <patrick.ohly@intel.com>
Cc: "trivial@kernel.org" <trivial@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] trivial: fix checking socket() in net tstamp example
Message-ID: <20091108175704.GB820@lilem.mirepesht>
References: <20091108155923.GA820@lilem.mirepesht>
 <1257701045.29123.288.camel@pohly-mobl1.ikn.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257701045.29123.288.camel@pohly-mobl1.ikn.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Patrick,

Patrick Ohly <patrick.ohly@intel.com> wrote:
> > --- a/Documentation/networking/timestamping/timestamping.c
> > +++ b/Documentation/networking/timestamping/timestamping.c
> > @@ -370,7 +370,7 @@ int main(int argc, char **argv)
> >  	}
> >  
> >  	sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
> > -	if (socket < 0)
> > +	if (sock < 0)
> 
> Argh, of course you are right. FWIW, acknowledged.

By the way, I tried igb hardware timestamp but HWTSTAMP_FILTER_ALL works
almost like HWTSTAMP_FILTER_PTP_*.  Isn't it supposed to timestamp all
of the incoming packets?  Maybe there is something wrong with my test
setup?

Thanks,
Ali
